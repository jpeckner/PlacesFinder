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

import CoordiNode
import CoordiNodeTestComponents
import Nimble
import Quick
import Shared
import SharedTestComponents
import SwiftDux
import SwiftDuxTestComponents

class SearchCoordinatorTests: QuickSpec {

    // swiftlint:disable function_body_length
    // swiftlint:disable implicitly_unwrapped_optional
    // swiftlint:disable line_length
    override func spec() {

        let stubKeywords = NonEmptyString.stubValue("abc")
        let stubSearchParams = SearchParams.stubValue()
        let stubInitialRequestAction = Search.ActivityAction.initialPageRequested(stubSearchParams)
        let stubNavController = UINavigationController()

        var mockAppStoreRelay: SubstatesSubscriberRelay<MockAppStore>!
        var mockSearchStoreRelay: StoreSubscriptionRelay<MockSearchStore>!
        var mockServiceContainer: ServiceContainer!
        var mockSearchPresenter: SearchPresenterProtocolMock!
        var mockStatePrism: SearchActivityStatePrismProtocolMock!
        var mockSearchActivityActionPrism: SearchActivityActionPrismProtocolMock!
        var mockSearchBackgroundViewModelBuilder: SearchBackgroundViewModelBuilderProtocolMock!
        var mockSearchLookupViewModelBuilder: SearchLookupViewModelBuilderProtocolMock!
        var mockSearchDetailsViewContextBuilder: SearchDetailsViewContextBuilderProtocolMock!
        var mockNavigationBarViewModelBuilder: NavigationBarViewModelBuilderProtocolMock!

        var coordinator: SearchCoordinator<MockAppStore, MockSearchStore>!

        func initCoordinator(statePrism: SearchActivityStatePrismProtocol) {
            let mockAppStore = MockAppStore()
            mockAppStoreRelay = SubstatesSubscriberRelay(store: mockAppStore,
                                                         equatableKeyPaths: Search.appStoreKeyPaths)

            let mockSearchStore = MockSearchStore()
            mockSearchStoreRelay = StoreSubscriptionRelay(store: mockSearchStore)

            mockServiceContainer = ServiceContainer.mockValue()
            mockSearchPresenter = SearchPresenterProtocolMock()
            mockSearchPresenter.rootViewController = stubNavController

            mockSearchActivityActionPrism = SearchActivityActionPrismProtocolMock()
            mockSearchActivityActionPrism.initialRequestActionLocationUpdateRequestBlockReturnValue = stubInitialRequestAction

            mockSearchBackgroundViewModelBuilder = SearchBackgroundViewModelBuilderProtocolMock()
            mockSearchBackgroundViewModelBuilder.buildViewModelAppCopyContentReturnValue = SearchBackgroundViewModel.stubValue()

            let lookupViewModel = SearchLookupViewModel(searchInputViewModel: .nonDispatching(content: .stubValue()),
                                                        child: .progress)
            mockSearchLookupViewModelBuilder = SearchLookupViewModelBuilderProtocolMock()
            mockSearchLookupViewModelBuilder.buildViewModelAppCopyContentLocationUpdateRequestBlockReturnValue = lookupViewModel

            mockSearchDetailsViewContextBuilder = SearchDetailsViewContextBuilderProtocolMock()

            mockNavigationBarViewModelBuilder = NavigationBarViewModelBuilderProtocolMock()
            mockNavigationBarViewModelBuilder.buildTitleViewModelCopyContentReturnValue = .stubValue()

            coordinator = SearchCoordinator(appStoreRelay: mockAppStoreRelay,
                                            searchStoreRelay: mockSearchStoreRelay,
                                            presenter: mockSearchPresenter,
                                            urlOpenerService: mockServiceContainer.urlOpenerService,
                                            statePrism: statePrism,
                                            actionPrism: mockSearchActivityActionPrism,
                                            backgroundViewModelBuilder: mockSearchBackgroundViewModelBuilder,
                                            lookupViewModelBuilder: mockSearchLookupViewModelBuilder,
                                            detailsViewContextBuilder: mockSearchDetailsViewContextBuilder,
                                            navigationBarViewModelBuilder: mockNavigationBarViewModelBuilder)
        }

        beforeEach {
            mockStatePrism = SearchActivityStatePrismProtocolMock()

            initCoordinator(statePrism: mockStatePrism)
        }

        describe("init") {
            beforeEach {
                let statePrism = SearchActivityStatePrism(locationAuthListener: LocationAuthListenerProtocolMock(),
                                                          locationRequestHandler: LocationRequestHandlerProtocolMock())
                initCoordinator(statePrism: statePrism)
            }

            it("subscribes to its relevant key paths") {
                let substatesSubscription =
                    mockAppStoreRelay.store.receivedSubscriptions.last?.subscription
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
                    expect(coordinator.rootViewController) === stubNavController
                }
            }

        }

        describe("SubstatesSubscriber") {

            describe("newState()") {

                context("else when mockStatePrism.presentationType() returns .noInternet") {

                    func performTest(linkType: AppLinkType?) {
                        let appState = AppState.stubValue(
                            routerState: RouterState(
                                loadState: linkType.map { .waitingForPayloadToBeCleared($0) } ?? .idle,
                                currentNode: StubNode.nodeBox
                            )
                        )

                        let searchState = Search.State.stub()
                        mockSearchStoreRelay.store.appendActionCallback = { action in
                            switch action {
                            case let .receiveState(stateReceiverBlock):
                                stateReceiverBlock.value(searchState)

                            case .searchActivity:
                                fail("Unexpected action received: \(action)")
                            }
                        }

                        mockStatePrism.presentationTypeLocationAuthStateReachabilityStateReturnValue = .noInternet

                        mockAppStoreRelay.newState(state: appState,
                                                   updatedSubstates: [\AppState.routerState])
                    }

                    it("calls presenter.loadNoInternetViews()") {
                        performTest(linkType: nil)
                        expect(mockSearchPresenter.loadNoInternetViewsTitleViewModelAppSkinCalled).toEventually(beTrue())
                    }

                    context("when the state has a pending .search linkType") {
                        beforeEach {
                            let payload = SearchLinkPayload(keywords: stubKeywords)
                            performTest(linkType: .search(payload))
                        }

                        it("dispatches AppRouterAction.clearLink") {
                            expect(mockAppStoreRelay.store.hasDispatchedRouterClearLinkAction).toEventually(beTrue())
                        }
                    }

                    context("else when the state has a pending .emptySearch linkType") {
                        beforeEach {
                            let payload = EmptySearchLinkPayload()
                            performTest(linkType: .emptySearch(payload))
                        }

                        it("dispatches AppRouterAction.clearLink") {
                            expect(mockAppStoreRelay.store.hasDispatchedRouterClearLinkAction).toEventually(beTrue())
                        }
                    }

                    context("else when the state has a pending linkType of a different type") {
                        var verificationBlock: NoDispatchVerificationBlock!

                        beforeEach {
                            verificationBlock = self.verifyNoDispatches(from: mockAppStoreRelay.store) {
                                performTest(linkType: .settings(SettingsLinkPayload()))
                            }
                        }

                        it("does not dispatch an action") {
                            verificationBlock()
                        }
                    }

                }

                context("else when mockStatePrism.presentationType() returns .locationServicesDisabled") {

                    func performTest(linkType: AppLinkType?) {
                        let appState = AppState.stubValue(
                            routerState: RouterState(
                                loadState: linkType.map { .waitingForPayloadToBeCleared($0) } ?? .idle,
                                currentNode: StubNode.nodeBox
                            )
                        )

                        let searchState = Search.State.stub()
                        mockSearchStoreRelay.store.appendActionCallback = { action in
                            switch action {
                            case let .receiveState(stateReceiverBlock):
                                stateReceiverBlock.value(searchState)

                            case .searchActivity:
                                fail("Unexpected action received: \(action)")
                            }
                        }

                        mockStatePrism.presentationTypeLocationAuthStateReachabilityStateReturnValue = .locationServicesDisabled

                        mockAppStoreRelay.newState(state: appState,
                                                   updatedSubstates: [\AppState.locationAuthState])
                    }

                    it("calls presenter.loadLocationServicesDisabledViews()") {
                        performTest(linkType: nil)
                        expect(mockSearchPresenter.loadLocationServicesDisabledViewsTitleViewModelAppSkinCalled)
                            .toEventually(beTrue())
                    }

                    context("when the state has a pending .search linkType") {
                        beforeEach {
                            let payload = SearchLinkPayload(keywords: stubKeywords)
                            performTest(linkType: .search(payload))
                        }

                        it("dispatches AppRouterAction.clearLink") {
                            expect(mockAppStoreRelay.store.hasDispatchedRouterClearLinkAction).toEventually(beTrue())
                        }
                    }

                    context("else when the state has a pending .emptySearch linkType") {
                        beforeEach {
                            let payload = EmptySearchLinkPayload()
                            performTest(linkType: .emptySearch(payload))
                        }

                        it("dispatches AppRouterAction.clearLink") {
                            expect(mockAppStoreRelay.store.hasDispatchedRouterClearLinkAction).toEventually(beTrue())
                        }
                    }

                    context("else when the state has a pending linkType of a different type") {
                        var verificationBlock: NoDispatchVerificationBlock!

                        beforeEach {
                            verificationBlock = self.verifyNoDispatches(from: mockAppStoreRelay.store) {
                                performTest(linkType: .settings(SettingsLinkPayload()))
                            }
                        }

                        it("does not dispatch an action") {
                            verificationBlock()
                        }
                    }

                }

                context("else when mockStatePrism.presentationType() returns .search(.locationServicesNotDetermined)") {
                    var blockCalled: Bool!

                    func performTest(currentNode: NodeBox) {
                        blockCalled = false

                        let appState = AppState.stubValue(
                            routerState: RouterState(currentNode: currentNode)
                        )

                        let searchState = Search.State.stub()
                        mockSearchStoreRelay.store.appendActionCallback = { action in
                            switch action {
                            case let .receiveState(stateReceiverBlock):
                                stateReceiverBlock.value(searchState)

                            case .searchActivity:
                                fail("Unexpected action received: \(action)")
                            }
                        }

                        mockStatePrism.presentationTypeLocationAuthStateReachabilityStateReturnValue =
                            .search(IgnoredEquatable(.locationServicesNotDetermined { blockCalled = true }))

                        mockAppStoreRelay.newState(state: appState,
                                                   updatedSubstates: [\AppState.routerState])
                    }

                    context("when SearchCoordinator is the currently active coordinator") {
                        beforeEach {
                            performTest(currentNode: SearchCoordinatorNode.nodeBox)
                        }

                        it("calls presenter.loadSearchBackgroundView()") {
                            expect(mockSearchPresenter.loadSearchBackgroundViewTitleViewModelAppSkinCalled).toEventually(beTrue())
                        }

                        it("invokes the provided authorization block") {
                            expect(blockCalled).toEventually(beTrue())
                        }
                    }

                    context("else when SearchCoordinator is not the currently active coordinator") {
                        beforeEach {
                            performTest(currentNode: StubNode.nodeBox)
                        }

                        it("calls presenter.loadSearchBackgroundView()") {
                            expect(mockSearchPresenter.loadSearchBackgroundViewTitleViewModelAppSkinCalled).toEventually(beTrue())
                        }

                        it("does not invoke the provided authorization block") {
                            expect(blockCalled) == false
                        }
                    }
                }

                context("else when mockStatePrism.presentationType() returns .search(.locationServicesEnabled)") {

                    func performTest(linkType: AppLinkType?) {
                        let loadState: RouterState.LoadState =
                            linkType.map { .waitingForPayloadToBeCleared($0) } ?? .idle
                        let appState = AppState.stubValue(
                            routerState: RouterState(loadState: loadState,
                                                     currentNode: StubNode.nodeBox)
                        )

                        let searchState = Search.State.stub()
                        mockSearchStoreRelay.store.appendActionCallback = { action in
                            print("Da action: \(action)")
                            switch action {
                            case let .receiveState(stateReceiverBlock):
                                stateReceiverBlock.value(searchState)

                            case .searchActivity:
                                break
                            }
                        }

                        mockStatePrism.presentationTypeLocationAuthStateReachabilityStateReturnValue =
                            .search(IgnoredEquatable(.locationServicesEnabled { _ in }))

                        mockAppStoreRelay.newState(state: appState,
                                                   updatedSubstates: [\AppState.routerState])
                    }

                    context("and the state has a pending .search linkType") {

                        beforeEach {
                            performTest(linkType: .search(SearchLinkPayload(keywords: stubKeywords)))
                        }

                        it("calls presenter.loadSearchViews()") {
                            expect(mockSearchPresenter.loadSearchViewsDetailsViewContextTitleViewModelAppSkinCalled).toEventually(beTrue())
                        }

                        it("dispatches AppRouterAction.clearLink") {
                            expect(mockAppStoreRelay.store.hasDispatchedRouterClearLinkAction).toEventually(beTrue())
                        }

                        it("calls actionCreator.requestInitialPage(:params)") {
                            expect(mockSearchActivityActionPrism.initialRequestActionLocationUpdateRequestBlockCalled).toEventually(beTrue())
                        }

                        it("dispatches the action returned by actionCreator.requestInitialPage(:params)") {
                            expect(mockSearchStoreRelay.store.hasDispatchedSearchActivityAction(activityAction: stubInitialRequestAction))
                                .toEventually(beTrue())
                        }

                    }

                    context("else and the state has a pending .emptySearch linkType") {
                        beforeEach {
                            performTest(linkType: .emptySearch(EmptySearchLinkPayload()))
                        }

                        it("calls presenter.loadSearchViews()") {
                            expect(mockSearchPresenter.loadSearchViewsDetailsViewContextTitleViewModelAppSkinCalled).toEventually(beTrue())
                        }

                        it("dispatches AppRouterAction.clearLink") {
                            expect(mockAppStoreRelay.store.hasDispatchedRouterClearLinkAction).toEventually(beTrue())
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
