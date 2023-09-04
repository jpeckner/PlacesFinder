//
//  SearchCoordinatorTests.swift
//  PlacesFinderTests
//
//  Copyright (c) 2018 Justin Peckner
//
//  Permission is hereby granted, free of charge, to any person obtaining a copy
//  of this software and associated documentation files (the "Software"), to deal
//  in the Software without restriction, including without limitation the rights
//  to use, copy, modify, merge, publish, distribute, sublicense, and/or sell
//  copies of the Software, and to permit persons to whom the Software is
//  furnished to do so, subject to the following conditions:
//
//  The above copyright notice and this permission notice shall be included in all
//  copies or substantial portions of the Software.
//
//  THE SOFTWARE IS PROVIDED "AS IS", WITHOUT WARRANTY OF ANY KIND, EXPRESS OR
//  IMPLIED, INCLUDING BUT NOT LIMITED TO THE WARRANTIES OF MERCHANTABILITY,
//  FITNESS FOR A PARTICULAR PURPOSE AND NONINFRINGEMENT. IN NO EVENT SHALL THE
//  AUTHORS OR COPYRIGHT HOLDERS BE LIABLE FOR ANY CLAIM, DAMAGES OR OTHER
//  LIABILITY, WHETHER IN AN ACTION OF CONTRACT, TORT OR OTHERWISE, ARISING FROM,
//  OUT OF OR IN CONNECTION WITH THE SOFTWARE OR THE USE OR OTHER DEALINGS IN THE
//  SOFTWARE.
//

import CoordiNode
import CoordiNodeTestComponents
import Nimble
import Quick
import Shared
import SharedTestComponents
import SwiftDux
import SwiftDuxTestComponents

// swiftlint:disable blanket_disable_command
// swiftlint:disable file_length
// swiftlint:disable force_try
// swiftlint:disable force_unwrapping
// swiftlint:disable function_body_length
// swiftlint:disable implicitly_unwrapped_optional
// swiftlint:disable line_length
// swiftlint:disable type_body_length
class SearchCoordinatorTests: QuickSpec {

    override func spec() {

        let stubKeywords = NonEmptyString.stubValue("abc")

        struct Dependencies {
            let stubInitialRequestAction = Search.ActivityAction.initialPageRequested(SearchParams.stubValue())
            let stubNavController = UINavigationController()

            let mockAppStoreRelay: SubstatesSubscriberRelay<MockAppStore>
            let mockSearchStoreRelay: StoreSubscriptionRelay<MockSearchStore>
            let mockServiceContainer: ServiceContainer
            let mockSearchPresenter: SearchPresenterProtocolMock
            let mockStatePrism: SearchActivityStatePrismProtocolMock
            let mockSearchActivityActionPrism: SearchActivityActionPrismProtocolMock
            let mockSearchBackgroundViewModelBuilder: SearchBackgroundViewModelBuilderProtocolMock
            let mockSearchLookupViewModelBuilder: SearchLookupViewModelBuilderProtocolMock
            let mockSearchDetailsViewContextBuilder: SearchDetailsViewContextBuilderProtocolMock
            let mockNavigationBarViewModelBuilder: NavigationBarViewModelBuilderProtocolMock

            @MainActor init() {
                let mockAppStore = MockAppStore()
                self.mockAppStoreRelay = SubstatesSubscriberRelay(
                    store: mockAppStore,
                    equatableKeyPaths: Search.appStoreKeyPaths
                )

                let mockSearchStore = MockSearchStore()
                self.mockSearchStoreRelay = StoreSubscriptionRelay(store: mockSearchStore)

                self.mockServiceContainer = ServiceContainer.mockValue()

                self.mockSearchPresenter = SearchPresenterProtocolMock()
                mockSearchPresenter.rootViewController = stubNavController

                self.mockStatePrism = SearchActivityStatePrismProtocolMock()

                self.mockSearchActivityActionPrism = SearchActivityActionPrismProtocolMock()
                mockSearchActivityActionPrism.initialRequestActionSearchParamsLocationUpdateRequestBlockReturnValue =
                    stubInitialRequestAction

                self.mockSearchBackgroundViewModelBuilder = SearchBackgroundViewModelBuilderProtocolMock()
                mockSearchBackgroundViewModelBuilder.buildViewModelKeywordsAppCopyContentColoringsReturnValue = SearchBackgroundViewModel.stubValue()

                let lookupViewModel = SearchLookupViewModel(
                    searchInputViewModel: .nonDispatching(content: .stubValue()),
                    child: .progress(.stubValue())
                )
                self.mockSearchLookupViewModelBuilder = SearchLookupViewModelBuilderProtocolMock()
                mockSearchLookupViewModelBuilder.buildViewModelSearchActivityStateAppCopyContentAppSkinLocationUpdateRequestBlockReturnValue = lookupViewModel

                self.mockSearchDetailsViewContextBuilder = SearchDetailsViewContextBuilderProtocolMock()

                self.mockNavigationBarViewModelBuilder = NavigationBarViewModelBuilderProtocolMock()
                mockNavigationBarViewModelBuilder.buildTitleViewModelCopyContentReturnValue = .stubValue()
            }
        }

        struct TestData {
            let dependencies: Dependencies
            let coordinator: SearchCoordinator<MockAppStore, MockSearchStore>
        }

        let testStorage = AsyncStorage<TestData>()

        beforeEach {
            Task { @MainActor in
                let dependencies = Dependencies()
                let coordinator = SearchCoordinator(
                    appStoreRelay: dependencies.mockAppStoreRelay,
                    searchStoreRelay: dependencies.mockSearchStoreRelay,
                    presenter: dependencies.mockSearchPresenter,
                    urlOpenerService: dependencies.mockServiceContainer.urlOpenerService,
                    statePrism: dependencies.mockStatePrism,
                    actionPrism: dependencies.mockSearchActivityActionPrism,
                    backgroundViewModelBuilder: dependencies.mockSearchBackgroundViewModelBuilder,
                    lookupViewModelBuilder: dependencies.mockSearchLookupViewModelBuilder,
                    detailsViewContextBuilder: dependencies.mockSearchDetailsViewContextBuilder,
                    navigationBarViewModelBuilder: dependencies.mockNavigationBarViewModelBuilder
                )
                let testData = TestData(dependencies: dependencies,
                                        coordinator: coordinator)

                await testStorage.setElement(testData)
            }

            try! await Task.sleep(nanoseconds: 100_000_000)
        }

        describe("init") {
            it("subscribes to its relevant key paths") {
                let testData = await testStorage.element!
                let substatesSubscription =
                    testData.dependencies.mockAppStoreRelay.store.receivedSubscriptions.last?.subscription
                    as? SubstatesSubscription<SubstatesSubscriberRelay<MockAppStore>>

                expect(substatesSubscription?.subscribedPaths.count) == 3
                expect(substatesSubscription?.subscribedPaths.keys.contains(\AppState.locationAuthState)) == true
                expect(substatesSubscription?.subscribedPaths.keys.contains(\AppState.reachabilityState)) == true
                expect(substatesSubscription?.subscribedPaths.keys.contains(\AppState.routerState)) == true
            }
        }

        describe("TabCoordinatorProtocol") {

            describe("rootViewController") {
                it("returns presenter.rootNavController") {
                    Task { @MainActor in
                        let testData = await testStorage.element!
                        expect(testData.coordinator.rootViewController) === testData.dependencies.stubNavController
                    }

                    try! await Task.sleep(nanoseconds: 100_000_000)
                }
            }

        }

        describe("SubstatesSubscriber") {

            describe("newState()") {

                context("else when mockStatePrism.presentationType() returns .noInternet") {

                    @Sendable func performTest(linkType: AppLinkType?) async {
                        let testData = await testStorage.element!
                        let appState = AppState.stubValue(
                            routerState: RouterState(
                                loadState: linkType.map { .waitingForPayloadToBeCleared($0) } ?? .idle,
                                currentNode: StubNode.nodeBox
                            )
                        )

                        let searchState = Search.State.stub()
                        testData.dependencies.mockSearchStoreRelay.store.appendActionCallback = { action in
                            switch action {
                            case let .receiveState(stateReceiverBlock):
                                stateReceiverBlock.value(searchState)

                            case .searchActivity:
                                fail("Unexpected action received: \(action)")
                            }
                        }

                        testData.dependencies.mockStatePrism.presentationTypeLocationAuthStateReachabilityStateReturnValue = .noInternet

                        testData.dependencies.mockAppStoreRelay.newState(state: appState,
                                                                         updatedSubstates: [\AppState.routerState])
                    }

                    it("calls presenter.loadNoInternetViews()") {
                        Task { @MainActor in
                            let testData = await testStorage.element!
                            await performTest(linkType: nil)
                            await expect(testData.dependencies.mockSearchPresenter.loadNoInternetViewsTitleViewModelAppSkinCalled)
                                .toEventually(beTrue())
                        }

                        try! await Task.sleep(nanoseconds: 100_000_000)
                    }

                    context("when the state has a pending .search linkType") {
                        beforeEach {
                            let payload = SearchLinkPayload(keywords: stubKeywords)
                            await performTest(linkType: .search(payload))
                        }

                        it("dispatches AppRouterAction.clearLink") {
                            let testData = await testStorage.element!
                            await expect(testData.dependencies.mockAppStoreRelay.store.hasDispatchedRouterClearLinkAction)
                                .toEventually(beTrue())
                        }
                    }

                    context("else when the state has a pending .emptySearch linkType") {
                        beforeEach {
                            let payload = EmptySearchLinkPayload()
                            await performTest(linkType: .emptySearch(payload))
                        }

                        it("dispatches AppRouterAction.clearLink") {
                            let testData = await testStorage.element!
                            await expect(testData.dependencies.mockAppStoreRelay.store.hasDispatchedRouterClearLinkAction).toEventually(beTrue())
                        }
                    }

                    context("else when the state has a pending linkType of a different type") {
                        var verificationBlock: NoDispatchVerificationBlock!

                        beforeEach {
                            let testData = await testStorage.element!
                            verificationBlock = self.verifyNoDispatches(from: testData.dependencies.mockAppStoreRelay.store) {
                                Task {
                                    await performTest(linkType: .settings(SettingsLinkPayload()))
                                }
                            }

                            try! await Task.sleep(nanoseconds: 100_000_000)
                        }

                        it("does not dispatch an action") {
                            verificationBlock()
                        }
                    }

                }

                context("else when mockStatePrism.presentationType() returns .locationServicesDisabled") {

                    @Sendable func performTest(linkType: AppLinkType?) async {
                        let testData = await testStorage.element!

                        let appState = AppState.stubValue(
                            routerState: RouterState(
                                loadState: linkType.map { .waitingForPayloadToBeCleared($0) } ?? .idle,
                                currentNode: StubNode.nodeBox
                            )
                        )

                        let searchState = Search.State.stub()
                        testData.dependencies.mockSearchStoreRelay.store.appendActionCallback = { action in
                            switch action {
                            case let .receiveState(stateReceiverBlock):
                                stateReceiverBlock.value(searchState)

                            case .searchActivity:
                                fail("Unexpected action received: \(action)")
                            }
                        }

                        testData.dependencies.mockStatePrism.presentationTypeLocationAuthStateReachabilityStateReturnValue
                            = .locationServicesDisabled

                        testData.dependencies.mockAppStoreRelay.newState(state: appState,
                                                                         updatedSubstates: [\AppState.locationAuthState])
                    }

                    it("calls presenter.loadLocationServicesDisabledViews()") {
                        Task { @MainActor in
                            let testData = await testStorage.element!
                            await performTest(linkType: nil)
                            await expect(testData.dependencies.mockSearchPresenter.loadLocationServicesDisabledViewsTitleViewModelAppSkinCalled)
                                .toEventually(beTrue())
                        }

                        try! await Task.sleep(nanoseconds: 100_000_000)
                    }

                    context("when the state has a pending .search linkType") {
                        beforeEach {
                            let payload = SearchLinkPayload(keywords: stubKeywords)
                            await performTest(linkType: .search(payload))
                        }

                        it("dispatches AppRouterAction.clearLink") {
                            let testData = await testStorage.element!
                            await expect(testData.dependencies.mockAppStoreRelay.store.hasDispatchedRouterClearLinkAction).toEventually(beTrue())
                        }
                    }

                    context("else when the state has a pending .emptySearch linkType") {
                        beforeEach {
                            let payload = EmptySearchLinkPayload()
                            await performTest(linkType: .emptySearch(payload))
                        }

                        it("dispatches AppRouterAction.clearLink") {
                            let testData = await testStorage.element!
                            await expect(testData.dependencies.mockAppStoreRelay.store.hasDispatchedRouterClearLinkAction).toEventually(beTrue())
                        }
                    }

                    context("else when the state has a pending linkType of a different type") {
                        var verificationBlock: NoDispatchVerificationBlock!

                        beforeEach {
                            let testData = await testStorage.element!
                            verificationBlock = self.verifyNoDispatches(from: testData.dependencies.mockAppStoreRelay.store) {
                                Task {
                                    await performTest(linkType: .settings(SettingsLinkPayload()))
                                }
                            }

                            try! await Task.sleep(nanoseconds: 100_000_000)
                        }

                        it("does not dispatch an action") {
                            verificationBlock()
                        }
                    }

                }

                context("else when mockStatePrism.presentationType() returns .search(.locationServicesNotDetermined)") {
                    var blockCalled: Bool!

                    func performTest(currentNode: NodeBox) async {
                        let testData = await testStorage.element!
                        blockCalled = false

                        let appState = AppState.stubValue(
                            routerState: RouterState(currentNode: currentNode)
                        )

                        let searchState = Search.State.stub()
                        testData.dependencies.mockSearchStoreRelay.store.appendActionCallback = { action in
                            switch action {
                            case let .receiveState(stateReceiverBlock):
                                stateReceiverBlock.value(searchState)

                            case .searchActivity:
                                fail("Unexpected action received: \(action)")
                            }
                        }

                        testData.dependencies.mockStatePrism.presentationTypeLocationAuthStateReachabilityStateReturnValue
                            = .search(IgnoredEquatable(.locationServicesNotDetermined { blockCalled = true }))

                        testData.dependencies.mockAppStoreRelay.newState(state: appState,
                                                                         updatedSubstates: [\AppState.routerState])
                    }

                    context("when SearchCoordinator is the currently active coordinator") {
                        beforeEach {
                            await performTest(currentNode: SearchCoordinatorNode.nodeBox)
                        }

                        it("calls presenter.loadSearchBackgroundView()") {
                            Task { @MainActor in
                                let testData = await testStorage.element!
                                await expect(testData.dependencies.mockSearchPresenter.loadSearchBackgroundViewTitleViewModelAppSkinCalled).toEventually(beTrue())
                            }

                            try! await Task.sleep(nanoseconds: 100_000_000)
                        }

                        it("invokes the provided authorization block") {
                            await expect(blockCalled).toEventually(beTrue())
                        }
                    }

                    context("else when SearchCoordinator is not the currently active coordinator") {
                        beforeEach {
                            await performTest(currentNode: StubNode.nodeBox)
                        }

                        it("calls presenter.loadSearchBackgroundView()") {
                            Task { @MainActor in
                                let testData = await testStorage.element!
                                await expect(testData.dependencies.mockSearchPresenter.loadSearchBackgroundViewTitleViewModelAppSkinCalled).toEventually(beTrue())
                            }

                            try! await Task.sleep(nanoseconds: 100_000_000)
                        }

                        it("does not invoke the provided authorization block") {
                            expect(blockCalled) == false
                        }
                    }
                }

                context("else when mockStatePrism.presentationType() returns .search(.locationServicesEnabled)") {

                    func performTest(linkType: AppLinkType?) async {
                        let testData = await testStorage.element!

                        let loadState: RouterState.LoadState =
                            linkType.map { .waitingForPayloadToBeCleared($0) } ?? .idle
                        let appState = AppState.stubValue(
                            routerState: RouterState(loadState: loadState,
                                                     currentNode: StubNode.nodeBox)
                        )

                        let searchState = Search.State.stub()
                        testData.dependencies.mockSearchStoreRelay.store.appendActionCallback = { action in
                            switch action {
                            case let .receiveState(stateReceiverBlock):
                                stateReceiverBlock.value(searchState)

                            case .searchActivity:
                                break
                            }
                        }

                        testData.dependencies.mockStatePrism.presentationTypeLocationAuthStateReachabilityStateReturnValue
                            = .search(IgnoredEquatable(.locationServicesEnabled { .success(.stubValue()) }))

                        testData.dependencies.mockAppStoreRelay.newState(state: appState,
                                                                         updatedSubstates: [\AppState.routerState])
                    }

                    context("and the state has a pending .search linkType") {

                        beforeEach {
                            await performTest(linkType: .search(SearchLinkPayload(keywords: stubKeywords)))
                        }

                        it("calls presenter.loadSearchViews()") {
                            Task { @MainActor in
                                let testData = await testStorage.element!
                                await expect(testData.dependencies.mockSearchPresenter.loadSearchViewsDetailsViewContextTitleViewModelAppSkinCalled).toEventually(beTrue())
                            }

                            try! await Task.sleep(nanoseconds: 100_000_000)
                        }

                        it("dispatches AppRouterAction.clearLink") {
                            let testData = await testStorage.element!
                            await expect(testData.dependencies.mockAppStoreRelay.store.hasDispatchedRouterClearLinkAction)
                                .toEventually(beTrue())
                        }

                        it("calls actionCreator.requestInitialPage(:params)") {
                            let testData = await testStorage.element!
                            await expect(testData.dependencies.mockSearchActivityActionPrism.initialRequestActionSearchParamsLocationUpdateRequestBlockCalled).toEventually(beTrue())
                        }

                        it("dispatches the action returned by actionCreator.requestInitialPage(:params)") {
                            let testData = await testStorage.element!
                            await expect(
                                testData.dependencies.mockSearchStoreRelay.store.hasDispatchedSearchActivityAction(
                                    activityAction: testData.dependencies.stubInitialRequestAction
                                )
                            )
                            .toEventually(beTrue())
                        }

                    }

                    context("else and the state has a pending .emptySearch linkType") {
                        beforeEach {
                            await performTest(linkType: .emptySearch(EmptySearchLinkPayload()))
                        }

                        it("calls presenter.loadSearchViews()") {
                            Task { @MainActor in
                                let testData = await testStorage.element!
                                await expect(testData.dependencies.mockSearchPresenter.loadSearchViewsDetailsViewContextTitleViewModelAppSkinCalled).toEventually(beTrue())
                            }

                            try! await Task.sleep(nanoseconds: 100_000_000)
                        }

                        it("dispatches AppRouterAction.clearLink") {
                            let testData = await testStorage.element!
                            await expect(testData.dependencies.mockAppStoreRelay.store.hasDispatchedRouterClearLinkAction).toEventually(beTrue())
                        }
                    }

                }

            }

        }

    }

}

private extension MockSearchStore {

    func hasDispatchedSearchActivityAction(activityAction: Search.ActivityAction) -> Bool {
        dispatchedActions.contains { action in
            action == .searchActivity(activityAction)
        }
    }

}

// swiftlint:enable blanket_disable_command
