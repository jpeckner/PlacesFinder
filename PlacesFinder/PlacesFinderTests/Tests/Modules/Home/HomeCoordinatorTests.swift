//
//  HomeCoordinatorTests.swift
//  PlacesFinderTests
//
//  Created by Justin Peckner.
//  Copyright © 2019 Justin Peckner. All rights reserved.
//

import CoordiNode
import Nimble
import Quick
import Shared
import SharedTestComponents
import SwiftDux
import SwiftDuxTestComponents
import UIKit

class HomeCoordinatorTests: QuickSpec {

    private typealias TFactory = HomeCoordinatorChildFactoryProtocolMock<MockAppStore>

    // swiftlint:disable function_body_length
    // swiftlint:disable implicitly_unwrapped_optional
    // swiftlint:disable line_length
    override func spec() {

        let dummyRootViewController = UIViewController()
        let dummySearchRootController = UIViewController()
        let dummySettingsRootController = UIViewController()

        var mockStore: MockAppStore!
        var mockSearchCoordinator: TabCoordinatorProtocolMock!
        var mockSettingsCoordinator: TabCoordinatorProtocolMock!
        var stubChildContainer: HomeCoordinatorChildContainer<TFactory>!
        var mockPresenter: HomePresenterProtocolMock!
        var mockAppRoutingHandler: AppRoutingHandlerProtocolMock!
        var coordinator: HomeCoordinator<TFactory>!

        beforeEach {
            mockStore = MockAppStore()

            mockSearchCoordinator = TabCoordinatorProtocolMock()
            mockSearchCoordinator.rootViewController = dummySearchRootController
            mockSettingsCoordinator = TabCoordinatorProtocolMock()
            mockSettingsCoordinator.rootViewController = dummySettingsRootController
            stubChildContainer = HomeCoordinatorChildContainer(search: mockSearchCoordinator,
                                                               settings: mockSettingsCoordinator)

            mockPresenter = HomePresenterProtocolMock()
            mockPresenter.rootViewController = dummyRootViewController

            mockAppRoutingHandler = AppRoutingHandlerProtocolMock()

            coordinator = HomeCoordinator(store: mockStore,
                                          childContainer: stubChildContainer,
                                          presenter: mockPresenter,
                                          appRoutingHandler: mockAppRoutingHandler)
        }

        func verifySetCurrentCoordinatorCalled(_ nodeBox: NodeBox) {
            let dispatchedAction = mockStore.dispatchedNonAsyncActions.last as? AppRouterAction
            expect(dispatchedAction) == .setCurrentCoordinator(nodeBox)
        }

        func verifySetDestinationCoordinatorCalled(_ destinationNodeBox: DestinationNodeBox,
                                                   linkType: AppLinkType) {
            let dispatchedAction = mockStore.dispatchedNonAsyncActions.last as? AppRouterAction
            expect(dispatchedAction) == .setDestinationCoordinator(destinationNodeBox, payload: linkType)
        }

        func verifyCoordinatorWasActivated(_ childCoordinator: TabCoordinatorProtocol,
                                           with nodeBox: NodeBox) {
            verifySetCurrentCoordinatorCalled(nodeBox)

            expect(mockPresenter.setSelectedViewControllerReceivedController) === childCoordinator.rootViewController
        }

        describe("ChildCoordinatorProtocol") {

            describe("rootViewController") {
                it("returns presenter.rootNavController") {
                    expect(coordinator.rootViewController) == mockPresenter.rootViewController
                }
            }

            describe("start()") {
                var completionCalled: Bool!

                beforeEach {
                    completionCalled = false

                    coordinator.start {
                        completionCalled = true
                    }
                }

                it("subscribes to its relevant key paths") {
                    let subscription =
                        mockStore.receivedSubscriptions.first?.subscription
                        as? SubstatesSubscription<HomeCoordinator<TFactory>>
                    expect(subscription?.subscribedPaths.count) == 1
                    expect(subscription?.subscribedPaths.keys.contains(\AppState.routerState)) == true
                }

                it("executes the completion block") {
                    expect(completionCalled) == true
                }
            }

            describe("finish()") {
                var completionCalled: Bool!

                beforeEach {
                    completionCalled = false

                    coordinator.finish {
                        completionCalled = true
                    }
                }

                it("unsubscribes from the store") {
                    expect(mockStore.receivedUnsubscribers.first as? HomeCoordinator<TFactory>) === coordinator
                }

                it("passes the completion block to mockLaunchPresenter for execution") {
                    expect(completionCalled) == true
                }
            }

        }

        describe("RouterProtocol") {

            describe("createSubtree()") {

                for destinationDescendent in HomeCoordinatorDestinationDescendent.allCases {
                    let immediateDescendent =
                        HomeCoordinatorDescendent(destinationDescendent: destinationDescendent).immediateDescendent

                    context("when createSubtree() is called to route towards \(destinationDescendent)") {
                        beforeEach {
                            coordinator.createSubtree(towards: destinationDescendent)
                        }

                        it("activates the corresponding coordinator") {
                            verifyCoordinatorWasActivated(stubChildContainer.coordinator(for: immediateDescendent),
                                                          with: immediateDescendent.nodeBox)
                        }
                    }
                }

            }

            describe("switchSubtree()") {

                for currentDescendent in HomeCoordinatorDescendent.allCases {
                    for destinationDescendent in HomeCoordinatorDestinationDescendent.allCases {
                        let immediateDescendent =
                            HomeCoordinatorDescendent(destinationDescendent: destinationDescendent).immediateDescendent

                        context("when switchSubtree() switches from \(currentDescendent) to \(destinationDescendent)") {
                            beforeEach {
                                coordinator.switchSubtree(from: currentDescendent,
                                                          to: destinationDescendent)
                            }

                            it("activates the corresponding coordinator") {
                                verifyCoordinatorWasActivated(stubChildContainer.coordinator(for: immediateDescendent),
                                                              with: immediateDescendent.nodeBox)
                            }
                        }
                    }
                }

            }

        }

        describe("TabSelectionViewControllerDelegate") {

            describe("didSelectIndex()") {

                for currentDescendentIdx in HomeCoordinatorDescendent.allCases.indices {
                    for (destinationDescedentIdx, destinationDescendent) in HomeCoordinatorDestinationDescendent.allCases.enumerated() {
                        let immediateDescendent =
                            HomeCoordinatorDescendent(destinationDescendent: destinationDescendent).immediateDescendent

                        context("when didSelectIndex() switches from index \(currentDescendentIdx) to index \(destinationDescedentIdx)") {
                            beforeEach {
                                coordinator.homePresenter(mockPresenter,
                                                          didSelectChildCoordinator: destinationDescedentIdx,
                                                          previousChildIndex: currentDescendentIdx)
                            }

                            it("activates the corresponding coordinator") {
                                verifyCoordinatorWasActivated(stubChildContainer.coordinator(for: immediateDescendent),
                                                              with: immediateDescendent.nodeBox)
                            }
                        }
                    }
                }

            }

        }

        describe("StoreSubscriber") {

            describe("newState()") {

                beforeEach {
                    coordinator.newState(state: .stubValue(),
                                         updatedSubstates: [])
                }

                it("calls mockAppRoutingHandler.handleRouting()") {
                    expect(mockAppRoutingHandler.handleRoutingUpdatedSubstatesRouterCalled) == true
                }

            }

        }

    }

}
