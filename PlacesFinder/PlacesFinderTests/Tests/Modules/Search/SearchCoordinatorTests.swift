//
//  SearchCoordinatorTests.swift
//  PlacesFinderTests
//
//  Created by Justin Peckner.
//  Copyright © 2018 Justin Peckner. All rights reserved.
//

import CoordiNode
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
        let stubkeywords = NonEmptyString.stubValue("abc")
        let stubNavController = UINavigationController()

        var mockStore: MockAppStore!
        var mockServiceContainer: ServiceContainer!
        var mockSearchPresenter: SearchPresenterProtocolMock!
        var mockStatePrism: SearchStatePrismProtocolMock!
        var mockSearchActionPrism: SearchActionPrismProtocolMock!
        var mockSearchBackgroundViewModelBuilder: SearchBackgroundViewModelBuilderProtocolMock!
        var mockSearchLookupViewModelBuilder: SearchLookupViewModelBuilderProtocolMock!
        var mockSearchDetailsViewContextBuilder: SearchDetailsViewContextBuilderProtocolMock!

        var coordinator: SearchCoordinator<MockAppStore>!

        func initCoordinator(statePrism: SearchStatePrismProtocol) {
            mockStore = MockAppStore()
            mockStore.stubState = stubState

            mockServiceContainer = ServiceContainer.mockValue()
            mockSearchPresenter = SearchPresenterProtocolMock()
            mockSearchPresenter.rootViewController = stubNavController

            mockSearchActionPrism = SearchActionPrismProtocolMock()
            mockSearchActionPrism.initialRequestActionLocationUpdateRequestBlockReturnValue = StubSearchAction.requestInitialPage

            mockSearchBackgroundViewModelBuilder = SearchBackgroundViewModelBuilderProtocolMock()
            mockSearchBackgroundViewModelBuilder.buildViewModelReturnValue = SearchBackgroundViewModel.stubValue()

            let searchInputViewModel = SearchInputViewModel(content: SearchInputContentViewModel.stubValue(),
                                                            store: mockStore,
                                                            actionPrism: mockSearchActionPrism) { _ in }
            let lookupViewModel = SearchLookupViewModel(searchInputViewModel: searchInputViewModel,
                                                        child: .progress)
            mockSearchLookupViewModelBuilder = SearchLookupViewModelBuilderProtocolMock()
            mockSearchLookupViewModelBuilder.buildViewModelActionPrismSearchStateAppCopyContentLocationUpdateRequestBlockReturnValue
                = lookupViewModel

            mockSearchDetailsViewContextBuilder = SearchDetailsViewContextBuilderProtocolMock()

            coordinator = SearchCoordinator(store: mockStore,
                                            presenter: mockSearchPresenter,
                                            urlOpenerService: mockServiceContainer.urlOpenerService,
                                            statePrism: statePrism,
                                            actionPrism: mockSearchActionPrism,
                                            backgroundViewModelBuilder: mockSearchBackgroundViewModelBuilder,
                                            lookupViewModelBuilder: mockSearchLookupViewModelBuilder,
                                            detailsViewContextBuilder: mockSearchDetailsViewContextBuilder)
        }

        beforeEach {
            mockStatePrism = SearchStatePrismProtocolMock()
            mockStatePrism.underlyingPresentationKeyPaths = []

            initCoordinator(statePrism: mockStatePrism)
        }

        describe("init") {
            beforeEach {
                let statePrism = SearchStatePrism(locationAuthListener: LocationAuthListenerProtocolMock(),
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
                            .search(IgnoredEquatable(.locationServicesEnabled(requestBlock: { _ in })))

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
                            let payload = SearchLinkPayload(keywords: stubkeywords)
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
                            let payload = SearchLinkPayload(keywords: stubkeywords)
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
                            .search(IgnoredEquatable(.locationServicesEnabled(requestBlock: { _ in })))

                        coordinator.newState(state: state,
                                             updatedSubstates: [\AppState.searchState])
                    }

                    context("and the state has a pending .search linkType") {

                        beforeEach {
                            performTest(linkType: .search(SearchLinkPayload(keywords: stubkeywords)))
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
                            expect(mockSearchActionPrism.initialRequestActionLocationUpdateRequestBlockCalled) == true
                        }

                        it("dispatches the action returned by actionCreator.requestInitialPage(:params)") {
                            let dispatchedAction = mockStore.dispatchedNonAsyncActions.last as? StubSearchAction
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
