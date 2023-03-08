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

    // swiftlint:disable force_try
    // swiftlint:disable force_unwrapping
    // swiftlint:disable function_body_length
    // swiftlint:disable implicitly_unwrapped_optional
    override func spec() {

        struct Dependencies {
            let stubRootViewController = UIViewController()

            let mockStore: MockAppStore
            let mockListenerContainer: ListenerContainer
            let mockLaunchPresenter: LaunchPresenterProtocolMock
            let mockStatePrism: LaunchStatePrismProtocolMock
            let mockStylingsHandler: AppGlobalStylingsHandlerProtocolMock

            @MainActor
            init() {
                self.mockStore = MockAppStore()
                self.mockListenerContainer = ListenerContainer.mockValue()
                self.mockLaunchPresenter = LaunchPresenterProtocolMock()
                mockLaunchPresenter.rootViewController = stubRootViewController
                self.mockStatePrism = LaunchStatePrismProtocolMock()
                mockStatePrism.underlyingLaunchKeyPaths = [EquatableKeyPath(\AppState.appSkinState)]
                self.mockStylingsHandler = AppGlobalStylingsHandlerProtocolMock()
            }
        }

        struct TestData {
            let dependencies: Dependencies
            let coordinator: LaunchCoordinator<MockAppStore>
        }

        let testStorage = AsyncStorage<TestData>()

        let stubSearchPayload: AppLinkType = .emptySearch(EmptySearchLinkPayload())
        let stubDefaultLinkType: AppLinkType = .settings(SettingsLinkPayload())

        beforeEach {
            Task { @MainActor in
                let dependencies = Dependencies()
                let coordinator = LaunchCoordinator(store: dependencies.mockStore,
                                                    presenter: dependencies.mockLaunchPresenter,
                                                    listenerContainer: dependencies.mockListenerContainer,
                                                    statePrism: dependencies.mockStatePrism,
                                                    stylingsHandler: dependencies.mockStylingsHandler,
                                                    defaultLinkType: stubDefaultLinkType)
                let testData = TestData(dependencies: dependencies,
                                        coordinator: coordinator)

                await testStorage.setElement(testData)
            }

            try! await Task.sleep(nanoseconds: 100_000_000)
        }

        describe("ChildCoordinatorProtocol") {

            describe("rootViewController") {
                it("returns presenter.rootNavController") {
                    Task { @MainActor in
                        let testData = await testStorage.element!
                        expect(testData.coordinator.rootViewController) === testData.dependencies.stubRootViewController
                    }

                    try! await Task.sleep(nanoseconds: 100_000_000)
                }
            }

            describe("start()") {
                beforeEach {
                    let testData = await testStorage.element!
                    await testData.coordinator.start()
                }

                it("subscribes to its relevant key paths") {
                    let testData = await testStorage.element!
                    let substatesSubscription =
                        testData.dependencies.mockStore.receivedSubscriptions.first?.subscription
                        as? SubstatesSubscription<LaunchCoordinator<MockAppStore>>
                    expect(substatesSubscription?.subscribedPaths.count) == 1
                    expect(substatesSubscription?.subscribedPaths.keys.contains(\AppState.appSkinState)) == true
                }

                it("dispatches the action returned by appSkinActionCreator.loadSkin()") {
                    let testData = await testStorage.element!
                    expect(testData.dependencies.mockStore.dispatchedActions.last) == .appSkin(.startLoad)
                }

                it("calls reachabilityListener.start()") {
                    let testData = await testStorage.element!
                    let listener =
                        testData.dependencies.mockListenerContainer.reachabilityListener
                        as? ReachabilityListenerProtocolMock
                    expect(listener?.startCalled) == true
                }

                it("calls userDefaultsListener.start()") {
                    let testData = await testStorage.element!
                    let listener =
                        testData.dependencies.mockListenerContainer.userDefaultsListener
                        as? UserDefaultsListenerProtocolMock
                    expect(listener?.startCalled) == true
                }
            }

            describe("finish()") {
                beforeEach {
                    let testData = await testStorage.element!
                    await testData.coordinator.finish()
                }

                it("unsubscribes from the store") {
                    let testData = await testStorage.element!
                    expect(
                        testData.dependencies.mockStore.receivedUnsubscribers.first
                        as? LaunchCoordinator<MockAppStore>
                    ) === testData.coordinator
                }
            }

        }

        describe("StoreSubscriber") {

            context("when mockStatePrism.hasFinishedLaunching returns false") {
                var verificationBlock: NoDispatchVerificationBlock!

                beforeEach {
                    let testData = await testStorage.element!

                    testData.dependencies.mockStatePrism.hasFinishedLaunchingReturnValue = false
                    let appState = AppState.stubValue(
                        routerState: RouterState(loadState: .idle,
                                                 currentNode: StubNode.nodeBox)
                    )

                    verificationBlock = self.verifyNoDispatches(from: testData.dependencies.mockStore) {
                        testData.coordinator.newState(state: appState,
                                                      updatedSubstates: [])
                    }
                }

                it("does not call mockStylingsHandler.apply()") {
                    let testData = await testStorage.element!
                    expect(testData.dependencies.mockStylingsHandler.applyCalled) == false
                }

                it("does not dispatch an action") {
                    verificationBlock()
                }
            }

            context("else when the state already has a payload requested") {
                var verificationBlock: NoDispatchVerificationBlock!

                beforeEach {
                    let testData = await testStorage.element!

                    testData.dependencies.mockStatePrism.hasFinishedLaunchingReturnValue = true
                    let appState = AppState.stubValue(
                        routerState: RouterState(loadState: .payloadRequested(stubSearchPayload),
                                                 currentNode: StubNode.nodeBox)
                    )

                    verificationBlock = self.verifyNoDispatches(from: testData.dependencies.mockStore) {
                        testData.coordinator.newState(state: appState,
                                                      updatedSubstates: [])
                    }

                    try! await Task.sleep(nanoseconds: 100_000_000)
                }

                it("calls mockStylingsHandler.apply()") {
                    let testData = await testStorage.element!
                    expect(testData.dependencies.mockStylingsHandler.applyCalled) == true
                }

                it("does not dispatch an action") {
                    verificationBlock()
                }
            }

            context("else when the state does not already have a payload requested") {
                beforeEach {
                    let testData = await testStorage.element!

                    testData.dependencies.mockStatePrism.hasFinishedLaunchingReturnValue = true
                    let appState = AppState.stubValue(
                        routerState: RouterState(loadState: .idle,
                                                 currentNode: StubNode.nodeBox)
                    )

                    testData.coordinator.newState(state: appState,
                                                  updatedSubstates: [\AppState.locationAuthState])
                }

                it("calls mockStylingsHandler.apply()") {
                    let testData = await testStorage.element!
                    await expect(testData.dependencies.mockStylingsHandler.applyCalled).toEventually(beTrue())
                }

                it("dispatches requestLink with stubDefaultLinkType") {
                    let testData = await testStorage.element!
                    let dispatchedAction = testData.dependencies.mockStore.dispatchedActions.last
                    expect(dispatchedAction) == .router(.requestLink(stubDefaultLinkType))
                }
            }

        }

    }

}
