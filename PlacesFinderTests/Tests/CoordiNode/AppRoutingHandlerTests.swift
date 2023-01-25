//
//  AppRoutingHandlerTests.swift
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

class AppRoutingHandlerTests: QuickSpec {

    // swiftlint:disable function_body_length
    // swiftlint:disable implicitly_unwrapped_optional
    // swiftlint:disable line_length
    override func spec() {

        var mockRoutingHandler: RoutingHandlerProtocolMock<RootCoordinatorMock>!
        var mockDestinationRoutingHandler: DestinationRoutingHandlerProtocolMock<SecondChildCoordinatorMock>!
        var appRoutingHandler: AppRoutingHandler!

        describe("determineRouting() for AppRouterProtocol") {

            var stubRouter: AppRootCoordinatorMock!

            beforeEach {
                stubRouter = AppRootCoordinatorMock()
                mockRoutingHandler = RoutingHandlerProtocolMock()
                mockDestinationRoutingHandler = DestinationRoutingHandlerProtocolMock()
                appRoutingHandler = AppRoutingHandler(routingHandler: mockRoutingHandler,
                                                      destinationRoutingHandler: mockDestinationRoutingHandler)
            }

            context("when updatedSubstates does not contain AppState.routerState") {
                beforeEach {
                    let stubState = AppState.stubValue()
                    appRoutingHandler.determineRouting(stubState,
                                                       updatedSubstates: [],
                                                       router: stubRouter)
                }

                it("does not call mockRoutingHandler.determineRouting()") {
                    expect(mockRoutingHandler.determineRoutingFromToForCalled) == false
                }
            }

            context("else when the state's destinationNodeBox value is nil") {
                beforeEach {
                    let stubState = AppState.stubValue(routerState: RouterState(currentNode: RootCoordinatorMock.nodeBox))
                    appRoutingHandler.determineRouting(stubState,
                                                       updatedSubstates: [\AppState.routerState],
                                                       router: stubRouter)
                }

                it("does not call mockRoutingHandler.determineRouting()") {
                    expect(mockRoutingHandler.determineRoutingFromToForCalled) == false
                }
            }

            context("else when the state's destinationNodeBox value is not a descendent of stubRouter") {
                beforeEach {
                    let routerState = RouterState<AppLinkType>(
                        loadState: .navigatingToDestination(StubDestinationNode.destinationNodeBox, linkType: nil),
                        currentNode: RootCoordinatorMock.nodeBox
                    )
                    let stubState = AppState.stubValue(routerState: routerState)

                    appRoutingHandler.determineRouting(stubState,
                                                       updatedSubstates: [\AppState.routerState],
                                                       router: stubRouter)
                }

                it("does not call mockRoutingHandler.determineRouting()") {
                    expect(mockRoutingHandler.determineRoutingFromToForCalled) == false
                }
            }

            context("else when the state's destinationNodeBox value is a descendent of stubRouter") {

                let routerState = RouterState<AppLinkType>(
                    loadState: .navigatingToDestination(SecondGrandchildCoordinatorMock.destinationNodeBox, linkType: nil),
                    currentNode: RootCoordinatorMock.nodeBox
                )
                let stubAppState = AppState.stubValue(routerState: routerState)

                func executeTest() {
                    appRoutingHandler.determineRouting(stubAppState,
                                                       updatedSubstates: [\AppState.routerState],
                                                       router: stubRouter)
                }

                context("when mockRoutingHandler.determineRouting() returns .createSubtree") {
                    let stubCurrentNode = StubNode.nodeBox
                    let stubDestination = RootCoordinatorMock.TDestinationDescendent.firstChild

                    beforeEach {
                        mockRoutingHandler.determineRoutingFromToForReturnValue = .createSubtree(
                            currentNode: stubCurrentNode,
                            destinationDescendent: stubDestination
                        )

                        executeTest()
                    }

                    it("calls stubRouter.createSubtree()") {
                        expect(stubRouter.createSubtreeCurrentNodeArgValue) == stubCurrentNode
                        expect(stubRouter.createSubtreeDestinationDescendentArgValue) == stubDestination
                        expect(stubRouter.createSubtreeStateArgValue) == stubAppState
                    }
                }

                context("else when mockRoutingHandler.determineRouting() returns .switchSubtree") {
                    let stubCurrentNode = RootCoordinatorMock.TDescendent.firstGrandchild
                    let stubDestination = RootCoordinatorMock.TDestinationDescendent.firstChild

                    beforeEach {
                        mockRoutingHandler.determineRoutingFromToForReturnValue = .switchSubtree(
                            currentNode: stubCurrentNode,
                            destinationDescendent: stubDestination
                        )

                        executeTest()
                    }

                    it("calls stubRouter.createSubtree()") {
                        expect(stubRouter.switchSubtreeCurrentNodeArgValue) == stubCurrentNode
                        expect(stubRouter.switchSubtreeDestinationDescendentArgValue) == stubDestination
                        expect(stubRouter.switchSubtreeStateArgValue) == stubAppState
                    }
                }

                context("else when mockRoutingHandler.determineRouting() returns nil") {
                    beforeEach {
                        mockRoutingHandler.determineRoutingFromToForReturnValue = nil

                        executeTest()
                    }

                    it("calls nothing on stubRouter") {
                        expect(stubRouter.createSubtreeCurrentNodeArgValue).to(beNil())
                        expect(stubRouter.switchSubtreeCurrentNodeArgValue).to(beNil())
                    }
                }

            }

        }

        describe("determineRouting() for AppDestinationRouterProtocol") {

            var stubDestinationRouter: AppSecondChildCoordinatorMock!

            beforeEach {
                stubDestinationRouter = AppSecondChildCoordinatorMock()
                mockRoutingHandler = RoutingHandlerProtocolMock()
                mockDestinationRoutingHandler = DestinationRoutingHandlerProtocolMock()
                appRoutingHandler = AppRoutingHandler(routingHandler: mockRoutingHandler,
                                                      destinationRoutingHandler: mockDestinationRoutingHandler)
            }

            context("when updatedSubstates does not contain AppState.routerState") {
                beforeEach {
                    let stubState = AppState.stubValue()
                    appRoutingHandler.determineRouting(stubState,
                                                       updatedSubstates: [],
                                                       router: stubDestinationRouter)
                }

                it("does not call mockRoutingHandler.determineRouting()") {
                    expect(mockRoutingHandler.determineRoutingFromToForCalled) == false
                }
            }

            context("else when the state's destinationNodeBox value is nil") {
                beforeEach {
                    let stubState = AppState.stubValue(routerState: RouterState(currentNode: RootCoordinatorMock.nodeBox))
                    appRoutingHandler.determineRouting(stubState,
                                                       updatedSubstates: [\AppState.routerState],
                                                       router: stubDestinationRouter)
                }

                it("does not call mockRoutingHandler.determineRouting()") {
                    expect(mockRoutingHandler.determineRoutingFromToForCalled) == false
                }
            }

            context("else when the state's destinationNodeBox value is a descendent of stubRouter") {

                let routerState = RouterState<AppLinkType>(
                    loadState: .navigatingToDestination(SecondGrandchildCoordinatorMock.destinationNodeBox, linkType: nil),
                    currentNode: RootCoordinatorMock.nodeBox
                )
                let stubAppState = AppState.stubValue(routerState: routerState)

                func executeTest() {
                    appRoutingHandler.determineRouting(stubAppState,
                                                       updatedSubstates: [\AppState.routerState],
                                                       router: stubDestinationRouter)
                }

                context("when mockRoutingHandler.determineRouting() returns .createSubtree") {
                    let stubCurrentNode = StubNode.nodeBox
                    let stubDestination = SecondChildCoordinatorMock.TDestinationDescendent.firstGrandchild

                    beforeEach {
                        mockDestinationRoutingHandler.determineRoutingFromToForReturnValue = .createSubtree(
                            currentNode: stubCurrentNode,
                            destinationDescendent: stubDestination
                        )

                        executeTest()
                    }

                    it("calls stubRouter.createSubtree()") {
                        expect(stubDestinationRouter.createSubtreeCurrentNodeArgValue) == stubCurrentNode
                        expect(stubDestinationRouter.createSubtreeDestinationDescendentArgValue) == stubDestination
                        expect(stubDestinationRouter.createSubtreeStateArgValue) == stubAppState
                    }
                }

                context("else when mockRoutingHandler.determineRouting() returns .switchSubtree") {
                    let stubCurrentNode = SecondChildCoordinatorMock.TDescendent.firstGrandchild
                    let stubDestination = SecondChildCoordinatorMock.TDestinationDescendent.secondGrandchild

                    beforeEach {
                        mockDestinationRoutingHandler.determineRoutingFromToForReturnValue = .switchSubtree(
                            currentNode: stubCurrentNode,
                            destinationDescendent: stubDestination
                        )

                        executeTest()
                    }

                    it("calls stubRouter.createSubtree()") {
                        expect(stubDestinationRouter.switchSubtreeCurrentNodeArgValue) == stubCurrentNode
                        expect(stubDestinationRouter.switchSubtreeDestinationDescendentArgValue) == stubDestination
                        expect(stubDestinationRouter.switchSubtreeStateArgValue) == stubAppState
                    }
                }

                context("else when mockRoutingHandler.determineRouting() returns .closeAllSubtrees") {
                    let stubCurrentNode = StubNode.nodeBox

                    beforeEach {
                        mockDestinationRoutingHandler.determineRoutingFromToForReturnValue = .closeAllSubtrees(
                            currentNode: stubCurrentNode
                        )

                        executeTest()
                    }

                    it("calls stubRouter.createSubtree()") {
                        expect(stubDestinationRouter.closeAllSubtreesCurrentNodeArgValue) == stubCurrentNode
                        expect(stubDestinationRouter.closeAllSubtreesStateArgValue) == stubAppState
                    }
                }

                context("else when mockRoutingHandler.determineRouting() returns nil") {
                    beforeEach {
                        mockRoutingHandler.determineRoutingFromToForReturnValue = nil

                        executeTest()
                    }

                    it("calls nothing on stubDestinationRouter") {
                        expect(stubDestinationRouter.createSubtreeCurrentNodeArgValue).to(beNil())
                        expect(stubDestinationRouter.switchSubtreeCurrentNodeArgValue).to(beNil())
                    }
                }

            }

        }

    }

}
