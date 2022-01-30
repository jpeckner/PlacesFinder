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

        let stubState = AppState.stubValue()
        let stubKeywords = NonEmptyString.stubValue("abc")
        let stubNavController = UINavigationController()

        var mockStore: MockAppStore!
        var mockServiceContainer: ServiceContainer!
        var mockSearchPresenter: SearchPresenterProtocolMock!
        var mockStatePrism: SearchActivityStatePrismProtocolMock!
        var mockSearchActivityActionPrism: SearchActivityActionPrismProtocolMock!
        var mockSearchBackgroundViewModelBuilder: SearchBackgroundViewModelBuilderProtocolMock!
        var mockSearchLookupViewModelBuilder: SearchLookupViewModelBuilderProtocolMock!
        var mockSearchDetailsViewContextBuilder: SearchDetailsViewContextBuilderProtocolMock!
        var mockNavigationBarViewModelBuilder: NavigationBarViewModelBuilderProtocolMock!

        var coordinator: SearchCoordinator<MockAppStore>!

        func initCoordinator(statePrism: SearchActivityStatePrismProtocol) {
            mockStore = MockAppStore()
            mockStore.stubState = stubState

            mockServiceContainer = ServiceContainer.mockValue()
            mockSearchPresenter = SearchPresenterProtocolMock()
            mockSearchPresenter.rootViewController = stubNavController

            mockSearchActivityActionPrism = SearchActivityActionPrismProtocolMock()
            mockSearchActivityActionPrism.initialRequestActionLocationUpdateRequestBlockReturnValue = StubSearchActivityAction.requestInitialPage

            mockSearchBackgroundViewModelBuilder = SearchBackgroundViewModelBuilderProtocolMock()
            mockSearchBackgroundViewModelBuilder.buildViewModelAppCopyContentReturnValue = SearchBackgroundViewModel.stubValue()

            let lookupViewModel = SearchLookupViewModel(searchInputViewModel: .nonDispatching(content: .stubValue()),
                                                        child: .progress)
            mockSearchLookupViewModelBuilder = SearchLookupViewModelBuilderProtocolMock()
            mockSearchLookupViewModelBuilder.buildViewModelAppCopyContentLocationUpdateRequestBlockReturnValue = lookupViewModel

            mockSearchDetailsViewContextBuilder = SearchDetailsViewContextBuilderProtocolMock()

            mockNavigationBarViewModelBuilder = NavigationBarViewModelBuilderProtocolMock()
            mockNavigationBarViewModelBuilder.buildTitleViewModelCopyContentReturnValue = .stubValue()

            coordinator = SearchCoordinator(store: mockStore,
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
            mockStatePrism.underlyingPresentationKeyPaths = []

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
                    mockStore.receivedSubscriptions.last?.subscription
                    as? SubstatesSubscription<SearchCoordinator<MockAppStore>>

                expect(substatesSubscription?.subscribedPaths.count) == 4
                expect(substatesSubscription?.subscribedPaths.keys.contains(\AppState.locationAuthState)) == true
                expect(substatesSubscription?.subscribedPaths.keys.contains(\AppState.reachabilityState)) == true
                expect(substatesSubscription?.subscribedPaths.keys.contains(\AppState.routerState)) == true
                expect(substatesSubscription?.subscribedPaths.keys.contains(\AppState.searchState)) == true
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

                context("when updatedSubstates have no values in common with mockStatePrism.presentationKeyPaths") {
                    var verificationBlock: NoDispatchVerificationBlock!

                    beforeEach {
                        mockStatePrism.presentationKeyPaths = []
                        mockStatePrism.presentationTypeForReturnValue =
                            .search(IgnoredEquatable(.locationServicesEnabled { _ in }))

                        verificationBlock = self.verifyNoDispatches(from: mockStore) {
                            coordinator.newState(state: AppState.stubValue(),
                                                 updatedSubstates: [\AppState.locationAuthState])
                        }
                    }

                    it("does not dispatch an action") {
                        verificationBlock()
                    }
                }

                context("else when mockStatePrism.presentationType() returns .noInternet") {

                    func performTest(linkType: AppLinkType?) {
                        let state = AppState.stubValue(
                            routerState: RouterState(
                                loadState: linkType.map { .waitingForPayloadToBeCleared($0) } ?? .idle,
                                currentNode: StubNode.nodeBox
                            )
                        )
                        mockStatePrism.presentationKeyPaths = [EquatableKeyPath(\AppState.reachabilityState)]
                        mockStatePrism.presentationTypeForReturnValue = .noInternet

                        coordinator.newState(state: state,
                                             updatedSubstates: [\AppState.reachabilityState])
                    }

                    it("calls presenter.loadNoInternetViews()") {
                        performTest(linkType: nil)
                        expect(mockSearchPresenter.loadNoInternetViewsTitleViewModelAppSkinCalled) == true
                    }

                    context("when the state has a pending .search linkType") {
                        beforeEach {
                            let payload = SearchLinkPayload(keywords: stubKeywords)
                            performTest(linkType: .search(payload))
                        }

                        it("dispatches AppRouterAction.clearLink") {
                            expect(mockStore.dispatchedNonAsyncActions.contains {
                                ($0 as? AppRouterAction) == .clearLink
                            }) == true
                        }
                    }

                    context("else when the state has a pending .emptySearch linkType") {
                        beforeEach {
                            let payload = EmptySearchLinkPayload()
                            performTest(linkType: .emptySearch(payload))
                        }

                        it("dispatches AppRouterAction.clearLink") {
                            expect(mockStore.dispatchedNonAsyncActions.contains {
                                ($0 as? AppRouterAction) == .clearLink
                            }) == true
                        }
                    }

                    context("else when the state has a pending linkType of a different type") {
                        var verificationBlock: NoDispatchVerificationBlock!

                        beforeEach {
                            verificationBlock = self.verifyNoDispatches(from: mockStore) {
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
                        let state = AppState.stubValue(
                            routerState: RouterState(
                                loadState: linkType.map { .waitingForPayloadToBeCleared($0) } ?? .idle,
                                currentNode: StubNode.nodeBox
                            )
                        )
                        mockStatePrism.presentationKeyPaths = [EquatableKeyPath(\AppState.locationAuthState)]
                        mockStatePrism.presentationTypeForReturnValue = .locationServicesDisabled

                        coordinator.newState(state: state,
                                             updatedSubstates: [\AppState.locationAuthState])
                    }

                    it("calls presenter.loadLocationServicesDisabledViews()") {
                        performTest(linkType: nil)
                        expect(mockSearchPresenter.loadLocationServicesDisabledViewsTitleViewModelAppSkinCalled) == true
                    }

                    context("when the state has a pending .search linkType") {
                        beforeEach {
                            let payload = SearchLinkPayload(keywords: stubKeywords)
                            performTest(linkType: .search(payload))
                        }

                        it("dispatches AppRouterAction.clearLink") {
                            expect(mockStore.dispatchedNonAsyncActions.contains {
                                ($0 as? AppRouterAction) == .clearLink
                            }) == true
                        }
                    }

                    context("else when the state has a pending .emptySearch linkType") {
                        beforeEach {
                            let payload = EmptySearchLinkPayload()
                            performTest(linkType: .emptySearch(payload))
                        }

                        it("dispatches AppRouterAction.clearLink") {
                            expect(mockStore.dispatchedNonAsyncActions.contains {
                                ($0 as? AppRouterAction) == .clearLink
                            }) == true
                        }
                    }

                    context("else when the state has a pending linkType of a different type") {
                        var verificationBlock: NoDispatchVerificationBlock!

                        beforeEach {
                            verificationBlock = self.verifyNoDispatches(from: mockStore) {
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
                        mockStatePrism.presentationTypeForReturnValue =
                            .search(IgnoredEquatable(.locationServicesNotDetermined { blockCalled = true }))
                        let state = AppState.stubValue(
                            routerState: RouterState(currentNode: currentNode)
                        )
                        mockStatePrism.presentationKeyPaths = [EquatableKeyPath(\AppState.searchState)]

                        coordinator.newState(state: state,
                                             updatedSubstates: [\AppState.searchState])
                    }

                    context("when SearchCoordinator is the currently active coordinator") {
                        beforeEach {
                            performTest(currentNode: SearchCoordinatorNode.nodeBox)
                        }

                        it("calls presenter.loadSearchBackgroundView()") {
                            expect(mockSearchPresenter.loadSearchBackgroundViewTitleViewModelAppSkinCalled) == true
                        }

                        it("invokes the provided authorization block") {
                            expect(blockCalled) == true
                        }
                    }

                    context("else when SearchCoordinator is not the currently active coordinator") {
                        beforeEach {
                            performTest(currentNode: StubNode.nodeBox)
                        }

                        it("calls presenter.loadSearchBackgroundView()") {
                            expect(mockSearchPresenter.loadSearchBackgroundViewTitleViewModelAppSkinCalled) == true
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
                        let state = AppState.stubValue(
                            routerState: RouterState(loadState: loadState,
                                                     currentNode: StubNode.nodeBox)
                        )
                        mockStatePrism.presentationKeyPaths = [EquatableKeyPath(\AppState.searchState)]
                        mockStatePrism.presentationTypeForReturnValue =
                            .search(IgnoredEquatable(.locationServicesEnabled { _ in }))

                        coordinator.newState(state: state,
                                             updatedSubstates: [\AppState.searchState])
                    }

                    context("and the state has a pending .search linkType") {

                        beforeEach {
                            performTest(linkType: .search(SearchLinkPayload(keywords: stubKeywords)))
                        }

                        it("calls presenter.loadSearchViews()") {
                            expect(mockSearchPresenter.loadSearchViewsDetailsViewContextTitleViewModelAppSkinCalled) == true
                        }

                        it("dispatches AppRouterAction.clearLink") {
                            expect(mockStore.dispatchedNonAsyncActions.contains {
                                ($0 as? AppRouterAction) == .clearLink
                            }) == true
                        }

                        it("calls actionCreator.requestInitialPage(:params)") {
                            expect(mockSearchActivityActionPrism.initialRequestActionLocationUpdateRequestBlockCalled) == true
                        }

                        it("dispatches the action returned by actionCreator.requestInitialPage(:params)") {
                            let dispatchedAction = mockStore.dispatchedNonAsyncActions.last as? StubSearchActivityAction
                            expect(dispatchedAction) == .requestInitialPage
                        }

                    }

                    context("else and the state has a pending .emptySearch linkType") {
                        beforeEach {
                            performTest(linkType: .emptySearch(EmptySearchLinkPayload()))
                        }

                        it("calls presenter.loadSearchViews()") {
                            expect(mockSearchPresenter.loadSearchViewsDetailsViewContextTitleViewModelAppSkinCalled) == true
                        }

                        it("dispatches AppRouterAction.clearLink") {
                            expect(mockStore.dispatchedNonAsyncActions.contains {
                                ($0 as? AppRouterAction) == .clearLink
                            }) == true
                        }
                    }

                }

            }

        }

    }

}
