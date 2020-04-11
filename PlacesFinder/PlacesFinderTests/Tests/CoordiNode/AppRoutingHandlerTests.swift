//
//  AppRoutingHandlerTests.swift
//  PlacesFinderTests
//
//  Created by Justin Peckner.
//  Copyright © 2019 Justin Peckner. All rights reserved.
//

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
                        loadState: .navigatingToDestination(StubDestinationNode.destinationNodeBox, payload: nil),
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
                        loadState: .navigatingToDestination(SecondGrandchildCoordinatorMock.destinationNodeBox, payload: nil),
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
