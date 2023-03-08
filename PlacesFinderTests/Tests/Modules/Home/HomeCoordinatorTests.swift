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

    // swiftlint:disable force_try
    // swiftlint:disable force_unwrapping
    // swiftlint:disable function_body_length
    // swiftlint:disable line_length
    override func spec() {

        struct Dependencies {
            let dummyRootViewController = UIViewController()
            let dummySearchRootController = UIViewController()
            let dummySettingsRootController = UIViewController()

            let mockStore = MockAppStore()
            let mockAppRoutingHandler = AppRoutingHandlerProtocolMock()
            let mockSearchCoordinator = TabCoordinatorProtocolMock()
            let mockSettingsCoordinator = TabCoordinatorProtocolMock()

            let stubChildContainer: HomeCoordinatorChildContainer<TFactory>
            let mockPresenter: HomePresenterProtocolMock

            @MainActor
            init() {
                self.mockPresenter = HomePresenterProtocolMock()
                self.stubChildContainer = HomeCoordinatorChildContainer(search: mockSearchCoordinator,
                                                                        settings: mockSettingsCoordinator)

                mockSearchCoordinator.rootViewController = dummySearchRootController
                mockSearchCoordinator.relinquishActiveCompletionClosure = { completion in
                    completion?()
                }

                mockSettingsCoordinator.rootViewController = dummySettingsRootController
                mockSettingsCoordinator.relinquishActiveCompletionClosure = { completion in
                    completion?()
                }

                mockPresenter.rootViewController = dummyRootViewController
            }
        }

        struct TestData {
            let dependencies: Dependencies
            let coordinator: HomeCoordinator<TFactory>
        }

        let testStorage = AsyncStorage<TestData>()

        beforeEach {
            Task { @MainActor in
                let dependencies = Dependencies()
                let coordinator = HomeCoordinator(
                    store: dependencies.mockStore,
                    childContainer: dependencies.stubChildContainer,
                    presenter: dependencies.mockPresenter,
                    appRoutingHandler: dependencies.mockAppRoutingHandler
                )

                let testData = TestData(dependencies: dependencies,
                                        coordinator: coordinator)
                await testStorage.setElement(testData)
            }

            try! await Task.sleep(nanoseconds: 100_000_000)
        }

        func verifySetDestinationCoordinatorCalled(_ destinationNodeBox: DestinationNodeBox,
                                                   linkType: AppLinkType) async {
            let testData = await testStorage.element!
            let dispatchedAction = testData.dependencies.mockStore.dispatchedActions.last
            expect(dispatchedAction) == .router(.setDestinationCoordinator(destinationNodeBox, payload: linkType))
        }

        @MainActor
        func verifyCoordinatorWasActivated(_ childCoordinator: TabCoordinatorProtocol,
                                           with nodeBox: NodeBox) async {
            let testData = await testStorage.element!
            let dispatchedAction = testData.dependencies.mockStore.dispatchedActions.last
            expect(dispatchedAction) == .router(.setCurrentCoordinator(nodeBox))

            expect(testData.dependencies.mockPresenter.setSelectedViewControllerReceivedController) ===
                childCoordinator.rootViewController
        }

        describe("ChildCoordinatorProtocol") {

            describe("rootViewController") {
                it("returns presenter.rootNavController") {
                    Task { @MainActor in
                        let testData = await testStorage.element!
                        expect(testData.coordinator.rootViewController) ==
                            testData.dependencies.mockPresenter.rootViewController
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
                    let subscription =
                        testData.dependencies.mockStore.receivedSubscriptions.first?.subscription
                        as? SubstatesSubscription<HomeCoordinator<TFactory>>
                    expect(subscription?.subscribedPaths.count) == 1
                    expect(subscription?.subscribedPaths.keys.contains(\AppState.routerState)) == true
                }
            }

            describe("finish()") {
                beforeEach {
                    let testData = await testStorage.element!
                    await testData.coordinator.finish()
                }

                it("unsubscribes from the store") {
                    let testData = await testStorage.element!
                    expect(testData.dependencies.mockStore.receivedUnsubscribers.first as? HomeCoordinator<TFactory>) === testData.coordinator
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
                            let testData = await testStorage.element!
                            await testData.coordinator.createSubtree(
                                from: HomeCoordinatorNode.nodeBox,
                                towards: destinationDescendent,
                                state: AppState.stubValue()
                            )
                        }

                        it("activates the corresponding coordinator") {
                            let testData = await testStorage.element!
                            await verifyCoordinatorWasActivated(
                                testData.dependencies.stubChildContainer.coordinator(for: immediateDescendent),
                                with: immediateDescendent.nodeBox
                            )
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
                                let testData = await testStorage.element!
                                await testData.coordinator.switchSubtree(
                                    from: currentDescendent,
                                    towards: destinationDescendent,
                                    state: AppState.stubValue()
                                )
                            }

                            it("activates the corresponding coordinator") {
                                let testData = await testStorage.element!
                                await verifyCoordinatorWasActivated(
                                    testData.dependencies.stubChildContainer.coordinator(for: immediateDescendent),
                                    with: immediateDescendent.nodeBox
                                )
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
                                let testData = await testStorage.element!
                                await testData.coordinator.homePresenter(
                                    testData.dependencies.mockPresenter,
                                    didSelectChildCoordinator: destinationDescedentIdx
                                )
                            }

                            it("activates the corresponding coordinator") {
                                let testData = await testStorage.element!
                                await verifyCoordinatorWasActivated(
                                    testData.dependencies.stubChildContainer.coordinator(for: immediateDescendent),
                                    with: immediateDescendent.nodeBox
                                )
                            }
                        }
                    }
                }

            }

        }

        describe("StoreSubscriber") {

            describe("newState()") {

                beforeEach {
                    let testData = await testStorage.element!
                    testData.coordinator.newState(state: .stubValue(),
                                                  updatedSubstates: [])
                }

                it("calls mockAppRoutingHandler.determineRouting()") {
                    let testData = await testStorage.element!
                    await expect(testData.dependencies.mockAppRoutingHandler
                        .determineRoutingUpdatedRoutingSubstatesRouterCalled).toEventually(beTrue())
                }

            }

        }

    }

}
