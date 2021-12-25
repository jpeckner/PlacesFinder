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

        let stubRouter = RootCoordinatorMock()

        var mockRoutingHandler: RoutingHandlerProtocolMock!
        var appRoutingHandler: AppRoutingHandler!

        beforeEach {
            mockRoutingHandler = RoutingHandlerProtocolMock()
            appRoutingHandler = AppRoutingHandler(routingHandler: mockRoutingHandler)
        }

        describe("handleRouting()") {

            context("when updatedSubstates does not contain AppState.routerState") {
                beforeEach {
                    let stubState = AppState.stubValue()
                    appRoutingHandler.handleRouting(stubState,
                                                    updatedSubstates: [],
                                                    router: stubRouter)
                }

                it("does not call mockRoutingHandler.handleRouting()") {
                    expect(mockRoutingHandler.handleRoutingFromToForCalled) == false
                }
            }

            context("else when the state's destinationNodeBox value is nil") {
                beforeEach {
                    let stubState = AppState.stubValue(routerState: RouterState(currentNode: RootCoordinatorMock.nodeBox))
                    appRoutingHandler.handleRouting(stubState,
                                                    updatedSubstates: [\AppState.routerState],
                                                    router: stubRouter)
                }

                it("does not call mockRoutingHandler.handleRouting()") {
                    expect(mockRoutingHandler.handleRoutingFromToForCalled) == false
                }
            }

            context("else when the state's destinationNodeBox value is not a descendent of stubRouter") {
                beforeEach {
                    let routerState = RouterState<AppLinkType>(
                        loadState: .navigatingToDestination(StubDestinationNode.destinationNodeBox, linkType: nil),
                        currentNode: RootCoordinatorMock.nodeBox
                    )
                    let stubState = AppState.stubValue(routerState: routerState)

                    appRoutingHandler.handleRouting(stubState,
                                                    updatedSubstates: [\AppState.routerState],
                                                    router: stubRouter)
                }

                it("does not call mockRoutingHandler.handleRouting()") {
                    expect(mockRoutingHandler.handleRoutingFromToForCalled) == false
                }
            }

            context("else when the state's destinationNodeBox value is a descendent of stubRouter") {
                beforeEach {
                    let routerState = RouterState<AppLinkType>(
                        loadState: .navigatingToDestination(SecondGrandchildCoordinatorMock.destinationNodeBox, linkType: nil),
                        currentNode: RootCoordinatorMock.nodeBox
                    )
                    let stubState = AppState.stubValue(routerState: routerState)

                    appRoutingHandler.handleRouting(stubState,
                                                    updatedSubstates: [\AppState.routerState],
                                                    router: stubRouter)
                }

                it("calls mockRoutingHandler.handleRouting()") {
                    expect(mockRoutingHandler.handleRoutingFromToForReceivedArguments?.0) == RootCoordinatorMock.nodeBox
                    expect(
                        mockRoutingHandler.handleRoutingFromToForReceivedArguments?.1
                        as? RootCoordinatorMockDestinationDescendent
                    ) == .secondGrandchild
                    expect(mockRoutingHandler.handleRoutingFromToForReceivedArguments?.2) === stubRouter
                }
            }

        }

    }

}
