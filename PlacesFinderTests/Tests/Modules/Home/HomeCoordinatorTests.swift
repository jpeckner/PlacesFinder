//
//  HomeCoordinatorTests.swift
//  PlacesFinderTests
//
//  Copyright (c) 2019 Justin Peckner
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
            mockSearchCoordinator.relinquishActiveCompletionClosure = { completion in
                completion?()
            }
            mockSettingsCoordinator = TabCoordinatorProtocolMock()
            mockSettingsCoordinator.rootViewController = dummySettingsRootController
            mockSettingsCoordinator.relinquishActiveCompletionClosure = { completion in
                completion?()
            }
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
            let dispatchedAction = mockStore.dispatchedActions.last
            expect(dispatchedAction) == .router(.setCurrentCoordinator(nodeBox))
        }

        func verifySetDestinationCoordinatorCalled(_ destinationNodeBox: DestinationNodeBox,
                                                   linkType: AppLinkType) {
            let dispatchedAction = mockStore.dispatchedActions.last
            expect(dispatchedAction) == .router(.setDestinationCoordinator(destinationNodeBox, payload: linkType))
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

        describe("AppRouterProtocol") {

            describe("createSubtree()") {

                for destinationDescendent in HomeCoordinatorDestinationDescendent.allCases {
                    let immediateDescendent =
                        HomeCoordinatorDescendent(destinationDescendent: destinationDescendent).immediateDescendent

                    context("when createSubtree() is called to route towards \(destinationDescendent)") {
                        beforeEach {
                            coordinator.createSubtree(from: HomeCoordinatorNode.nodeBox,
                                                      towards: destinationDescendent,
                                                      state: AppState.stubValue())
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
                                                          towards: destinationDescendent,
                                                          state: AppState.stubValue())
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
                                                          didSelectChildCoordinator: destinationDescedentIdx)
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

                it("calls mockAppRoutingHandler.determineRouting()") {
                    expect(mockAppRoutingHandler.determineRoutingUpdatedSubstatesRouterCalled) == true
                }

            }

        }

    }

}
