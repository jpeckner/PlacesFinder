//
//  AppCoordinatorTests.swift
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

private class MockHomeCoordinator: ChildCoordinatorProtocolMock, AppCoordinatorChildProtocol {
    static var appCoordinatorImmediateDescendent: AppCoordinatorImmediateDescendent {
        return .home
    }
}

private class MockLaunchCoordinator: ChildCoordinatorProtocolMock, AppCoordinatorChildProtocol {
    static var appCoordinatorImmediateDescendent: AppCoordinatorImmediateDescendent {
        return .launch
    }
}

class AppCoordinatorTests: QuickSpec {

    private typealias FactoryType = AppCoordinatorChildFactoryProtocolMock<MockAppStore>

    // swiftlint:disable function_body_length
    // swiftlint:disable implicitly_unwrapped_optional
    override func spec() {

        let stubLinkType: AppLinkType = .settings(SettingsLinkPayload())

        var mockMainWindow: UIWindowProtocolMock!
        var mockStore: MockAppStore!
        var mockChildFactory: FactoryType!
        var mockAppRoutingHandler: AppRoutingHandlerProtocolMock!
        var mockPayloadBuilder: AppLinkTypeBuilderProtocolMock!
        var mockLaunchStatePrism: LaunchStatePrismProtocolMock!

        var mockLaunchCoordinator: MockLaunchCoordinator!
        let dummyLaunchViewController = UIViewController()

        var mockHomeCoordinator: MockHomeCoordinator!
        let dummySearchRootController = UIViewController()

        var coordinator: AppCoordinator<FactoryType>!

        func initCoordinator(launchStatePrism: LaunchStatePrismProtocol) {
            mockMainWindow = UIWindowProtocolMock()
            mockStore = MockAppStore()
            mockChildFactory = AppCoordinatorChildFactoryProtocolMock()
            mockPayloadBuilder = AppLinkTypeBuilderProtocolMock()

            mockLaunchCoordinator = MockLaunchCoordinator()
            mockLaunchCoordinator.startClosure = { completion in completion() }
            mockLaunchCoordinator.rootViewController = dummyLaunchViewController
            mockLaunchCoordinator.finishClosure = { completion in completion?() }

            mockHomeCoordinator = MockHomeCoordinator()
            mockHomeCoordinator.startClosure = { completion in completion() }
            mockHomeCoordinator.rootViewController = dummySearchRootController

            mockChildFactory.store = mockStore
            mockAppRoutingHandler = AppRoutingHandlerProtocolMock()
            mockChildFactory.serviceContainer = ServiceContainer.mockValue(appRoutingHandler: mockAppRoutingHandler)
            mockChildFactory.launchStatePrism = launchStatePrism
            mockChildFactory.buildLaunchCoordinatorReturnValue = mockLaunchCoordinator
            mockChildFactory.buildCoordinatorForClosure = { _ in mockHomeCoordinator }

            coordinator = AppCoordinator(mainWindow: mockMainWindow,
                                         childFactory: mockChildFactory,
                                         payloadBuilder: mockPayloadBuilder)
        }

        beforeEach {
            mockLaunchStatePrism = LaunchStatePrismProtocolMock()
            mockLaunchStatePrism.underlyingLaunchKeyPaths = []

            initCoordinator(launchStatePrism: mockLaunchStatePrism)
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

        func verifyCoordinatorWasActivated(_ childCoordinator: ChildCoordinatorProtocolMock,
                                           with nodeBox: NodeBox,
                                           rootViewController: UIViewController) {
            verifySetCurrentCoordinatorCalled(nodeBox)

            expect(childCoordinator.startCalled) == true
            expect(mockMainWindow.rootViewController) === rootViewController
        }

        // MARK: Tests

        describe("start()") {

            beforeEach {
                let launchStatePrism = LaunchStatePrism()
                initCoordinator(launchStatePrism: launchStatePrism)
                coordinator.start()
            }

            it("activates the coordinator returned by mockChildFactory.buildLaunchCoordinator()") {
                verifyCoordinatorWasActivated(mockLaunchCoordinator,
                                              with: LaunchCoordinatorNode.nodeBox,
                                              rootViewController: dummyLaunchViewController)
            }

            it("subscribes to its relevant key paths") {
                let substatesSubscription =
                    mockStore.receivedSubscriptions.first?.subscription
                        as? SubstatesSubscription<AppCoordinator<FactoryType>>
                expect(substatesSubscription?.subscribedPaths.count) == 2
                expect(substatesSubscription?.subscribedPaths.keys.contains(\AppState.appSkinState)) == true
                expect(substatesSubscription?.subscribedPaths.keys.contains(\AppState.routerState)) == true
            }

        }

        describe("AppRouterProtocol") {

            describe("createSubtree()") {

                for destinationDescendent in AppCoordinatorDestinationDescendent.allCases {
                    context("when createSubtree() is called to route towards \(destinationDescendent)") {
                        beforeEach {
                            coordinator.createSubtree(from: AppCoordinatorNode.nodeBox,
                                                      towards: destinationDescendent,
                                                      state: AppState.stubValue())
                        }

                        it("activates mockHomeCoordinator") {
                            verifyCoordinatorWasActivated(mockHomeCoordinator,
                                                          with: HomeCoordinatorNode.nodeBox,
                                                          rootViewController: dummySearchRootController)
                        }
                    }
                }

            }

            describe("switchSubtree()") {

                for descendent in AppCoordinatorDescendent.allCases {
                    for destinationDescendent in AppCoordinatorDestinationDescendent.allCases {
                        context("when switchSubtree() switches from \(descendent) to \(destinationDescendent)") {
                            beforeEach {
                                coordinator.switchSubtree(from: descendent,
                                                          towards: destinationDescendent,
                                                          state: AppState.stubValue())
                            }

                            it("deactivates the current child coordinator") {
                                expect(mockLaunchCoordinator.finishCalled) == true
                            }

                            it("activates mockHomeCoordinator") {
                                verifyCoordinatorWasActivated(mockHomeCoordinator,
                                                              with: HomeCoordinatorNode.nodeBox,
                                                              rootViewController: dummySearchRootController)
                            }
                        }
                    }
                }

            }

        }

        describe("LinkHandlerProtocol") {

            describe("handleURL()") {

                var result: Bool!

                context("when payloadBuilder.buildPayload() returns nil") {
                    var verificationBlock: NoDispatchVerificationBlock!

                    beforeEach {
                        mockPayloadBuilder.buildPayloadReturnValue = nil

                        verificationBlock = self.verifyNoDispatches(from: mockStore) {
                            result = coordinator.handleURL(URL.stubValue())
                        }
                    }

                    it("returns false") {
                        expect(result) == false
                    }

                    it("does not dispatch an action") {
                        verificationBlock()
                    }
                }

                context("when payloadBuilder.buildPayload() returns a non-nil value") {

                    beforeEach {
                        mockStore.stubState = AppState.stubValue()
                        mockPayloadBuilder.buildPayloadReturnValue = stubLinkType
                        result = coordinator.handleURL(URL.stubValue())
                    }

                    it("returns true") {
                        expect(result) == true
                    }

                    it("dispatches RouterAction.requestLink with the payload") {
                        let dispatchedAction = mockStore.dispatchedNonAsyncActions.last as? AppRouterAction
                        expect(dispatchedAction) == .requestLink(stubLinkType)
                    }

                }

            }

        }

        describe("StoreSubscriber") {

            describe("newState()") {

                context("when mockStatePrism.hasFinishedLaunching returns false") {
                    var verificationBlock: NoDispatchVerificationBlock!

                    beforeEach {
                        mockLaunchStatePrism.hasFinishedLaunchingReturnValue = false
                        let appState = AppState.stubValue(
                            routerState: RouterState(loadState: .payloadRequested(stubLinkType),
                                                     currentNode: StubNode.nodeBox)
                        )

                        verificationBlock = self.verifyNoDispatches(from: mockStore) {
                            coordinator.newState(state: appState,
                                                 updatedSubstates: [])
                        }
                    }

                    it("calls mockAppRoutingHandler.determineRouting()") {
                        expect(mockAppRoutingHandler.determineRoutingUpdatedSubstatesRouterCalled) == true
                    }

                    it("does not dispatch an action") {
                        verificationBlock()
                    }
                }

                context("else when the state already has a payload requested") {
                    beforeEach {
                        mockLaunchStatePrism.hasFinishedLaunchingReturnValue = true
                        let appState = AppState.stubValue(
                            routerState: RouterState(loadState: .payloadRequested(stubLinkType),
                                                     currentNode: StubNode.nodeBox)
                        )

                        coordinator.newState(state: appState,
                                             updatedSubstates: [])
                    }

                    it("calls mockAppRoutingHandler.determineRouting()") {
                        expect(mockAppRoutingHandler.determineRoutingUpdatedSubstatesRouterCalled) == true
                    }

                    it("dispatches setDestinationCoordinator with the payload's destinationNodeBox") {
                        verifySetDestinationCoordinatorCalled(stubLinkType.destinationNodeBox,
                                                              linkType: stubLinkType)
                    }
                }

                context("else when the state does not already have a payload requested") {
                    var verificationBlock: NoDispatchVerificationBlock!

                    beforeEach {
                        mockLaunchStatePrism.hasFinishedLaunchingReturnValue = true
                        let appState = AppState.stubValue(
                            routerState: RouterState(loadState: .idle,
                                                     currentNode: StubNode.nodeBox)
                        )

                        verificationBlock = self.verifyNoDispatches(from: mockStore) {
                            coordinator.newState(state: appState,
                                                 updatedSubstates: [])
                        }
                    }

                    it("calls mockAppRoutingHandler.determineRouting()") {
                        expect(mockAppRoutingHandler.determineRoutingUpdatedSubstatesRouterCalled) == true
                    }

                    it("does not dispatch an action") {
                        verificationBlock()
                    }
                }

            }

        }

    }

}
