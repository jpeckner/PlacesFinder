//
//  LaunchCoordinatorTests.swift
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

import CoordiNodeTestComponents
import Nimble
import Quick
import Shared
import SharedTestComponents
import SwiftDux
import SwiftDuxTestComponents
import UIKit

class LaunchCoordinatorTests: QuickSpec {

    // swiftlint:disable function_body_length
    // swiftlint:disable implicitly_unwrapped_optional
    override func spec() {

        let stubSearchPayload: AppLinkType = .emptySearch(EmptySearchLinkPayload())
        let stubDefaultLinkType: AppLinkType = .settings(SettingsLinkPayload())
        let stubRootViewController = UIViewController()

        var mockStore: MockAppStore!
        var mockListenerContainer: ListenerContainer!
        var mockServiceContainer: ServiceContainer!
        var mockLaunchPresenter: LaunchPresenterProtocolMock!
        var mockStatePrism: LaunchStatePrismProtocolMock!
        var mockStylingsHandler: AppGlobalStylingsHandlerProtocolMock!
        var coordinator: LaunchCoordinator<MockAppStore>!

        func initCoordinator(statePrism: LaunchStatePrismProtocol) {
            mockStore = MockAppStore()
            mockListenerContainer = ListenerContainer.mockValue()
            mockServiceContainer = ServiceContainer.mockValue()
            mockLaunchPresenter = LaunchPresenterProtocolMock()
            mockLaunchPresenter.rootViewController = stubRootViewController
            mockStylingsHandler = AppGlobalStylingsHandlerProtocolMock()

            coordinator = LaunchCoordinator(store: mockStore,
                                            presenter: mockLaunchPresenter,
                                            listenerContainer: mockListenerContainer,
                                            statePrism: statePrism,
                                            stylingsHandler: mockStylingsHandler,
                                            defaultLinkType: stubDefaultLinkType)
        }

        beforeEach {
            mockStatePrism = LaunchStatePrismProtocolMock()
            mockStatePrism.underlyingLaunchKeyPaths = []

            initCoordinator(statePrism: mockStatePrism)
        }

        describe("ChildCoordinatorProtocol") {

            describe("rootViewController") {
                it("returns presenter.rootNavController") {
                    expect(coordinator.rootViewController) === stubRootViewController
                }
            }

            describe("start()") {
                var completionCalled: Bool!

                beforeEach {
                    let statePrism = LaunchStatePrism()
                    initCoordinator(statePrism: statePrism)

                    completionCalled = false
                    coordinator.start {
                        completionCalled = true
                    }
                }

                it("subscribes to its relevant key paths") {
                    let substatesSubscription =
                        mockStore.receivedSubscriptions.first?.subscription
                        as? SubstatesSubscription<LaunchCoordinator<MockAppStore>>
                    expect(substatesSubscription?.subscribedPaths.count) == 1
                    expect(substatesSubscription?.subscribedPaths.keys.contains(\AppState.appSkinState)) == true
                }

                it("dispatches the action returned by appSkinActionCreator.loadSkin()") {
                    expect(mockStore.dispatchedActions.last as? AppSkinAction) == .startLoad
                }

                it("calls reachabilityListener.start()") {
                    let listener = mockListenerContainer.reachabilityListener as? ReachabilityListenerProtocolMock
                    expect(listener?.startCalled) == true
                }

                it("calls userDefaultsListener.start()") {
                    let listener = mockListenerContainer.userDefaultsListener as? UserDefaultsListenerProtocolMock
                    expect(listener?.startCalled) == true
                }

                it("executes the completion block") {
                    expect(completionCalled) == true
                }
            }

            describe("finish()") {
                var completionCalled: Bool!

                beforeEach {
                    mockLaunchPresenter.animateOutClosure = { completionBlockReceived in
                        completionBlockReceived?()
                    }
                    completionCalled = false

                    coordinator.finish {
                        completionCalled = true
                    }
                }

                it("unsubscribes from the store") {
                    expect(mockStore.receivedUnsubscribers.first as? LaunchCoordinator<MockAppStore>) === coordinator
                }

                it("passes the completion block to mockLaunchPresenter for execution") {
                    expect(completionCalled) == true
                }
            }

        }

        describe("StoreSubscriber") {

            func verifyRequestLinkCalled(_ appLinkType: AppLinkType) {
                let dispatchedAction = mockStore.dispatchedActions.last
                expect(dispatchedAction) == .router(.requestLink(appLinkType))
            }

            context("when mockStatePrism.hasFinishedLaunching returns false") {
                var verificationBlock: NoDispatchVerificationBlock!

                beforeEach {
                    mockStatePrism.hasFinishedLaunchingReturnValue = false
                    let appState = AppState.stubValue(
                        routerState: RouterState(loadState: .idle,
                                                 currentNode: StubNode.nodeBox)
                    )

                    verificationBlock = self.verifyNoDispatches(from: mockStore) {
                        coordinator.newState(state: appState,
                                             updatedSubstates: [])
                    }
                }

                it("does not call mockStylingsHandler.apply()") {
                    expect(mockStylingsHandler.applyCalled) == false
                }

                it("does not dispatch an action") {
                    verificationBlock()
                }
            }

            context("else when the state already has a payload requested") {
                var verificationBlock: NoDispatchVerificationBlock!

                beforeEach {
                    mockStatePrism.hasFinishedLaunchingReturnValue = true
                    let appState = AppState.stubValue(
                        routerState: RouterState(loadState: .payloadRequested(stubSearchPayload),
                                                 currentNode: StubNode.nodeBox)
                    )

                    verificationBlock = self.verifyNoDispatches(from: mockStore) {
                        coordinator.newState(state: appState,
                                             updatedSubstates: [])
                    }
                }

                it("calls mockStylingsHandler.apply()") {
                    expect(mockStylingsHandler.applyCalled) == true
                }

                it("does not dispatch an action") {
                    verificationBlock()
                }
            }

            context("else when the state does not already have a payload requested") {
                beforeEach {
                    mockStatePrism.hasFinishedLaunchingReturnValue = true
                    let appState = AppState.stubValue(
                        routerState: RouterState(loadState: .idle,
                                                 currentNode: StubNode.nodeBox)
                    )

                    coordinator.newState(state: appState,
                                         updatedSubstates: [\AppState.locationAuthState])
                }

                it("calls mockStylingsHandler.apply()") {
                    expect(mockStylingsHandler.applyCalled) == true
                }

                it("dispatches requestLink with stubDefaultLinkType") {
                    verifyRequestLinkCalled(stubDefaultLinkType)
                }
            }

        }

    }

}
