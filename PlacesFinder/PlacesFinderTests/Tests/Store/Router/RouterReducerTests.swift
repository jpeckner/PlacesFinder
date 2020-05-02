//
//  RouterReducerTests.swift
//  PlacesFinderTests
//
//  Created by Justin Peckner.
//  Copyright © 2019 Justin Peckner. All rights reserved.
//

import CoordiNode
import CoordiNodeTestComponents
import Nimble
import Quick
import SwiftDuxTestComponents

private enum OtherStubNode: NodeProtocol {}

class RouterReducerTests: QuickSpec {

    // swiftlint:disable function_body_length
    // swiftlint:disable implicitly_unwrapped_optional
    // swiftlint:disable line_length
    override func spec() {

        let stubPayload = StubLinkType()

        describe("reduce") {

            var result: RouterState<StubLinkType>!

            context("when the action is not a RouterAction") {
                let currentState = RouterState<StubLinkType>(currentNode: StubNode.nodeBox)

                beforeEach {
                    result = RouterReducer.reduce(action: StubAction.genericAction,
                                                  currentState: currentState)
                }

                it("returns the current state") {
                    expect(result) == currentState
                }
            }

            context("else when the action is RouterAction.setCurrentCoordinator") {

                context("and the loadState before reducing is .idle") {
                    beforeEach {
                        let action = RouterAction<StubLinkType>.setCurrentCoordinator(OtherStubNode.nodeBox)
                        let currentState = RouterState<StubLinkType>(loadState: .idle,
                                                                     currentNode: StubNode.nodeBox)

                        result = RouterReducer.reduce(action: action,
                                                      currentState: currentState)
                    }

                    it("returns a state with currentNode equal to .setCurrentCoordinator's value, and otherwise unchanged") {
                        expect(result) == RouterState<StubLinkType>(loadState: .idle,
                                                                    currentNode: OtherStubNode.nodeBox)
                    }
                }

                context("and the loadState before reducing is .payloadRequested") {
                    beforeEach {
                        let action = RouterAction<StubLinkType>.setCurrentCoordinator(OtherStubNode.nodeBox)
                        let currentState = RouterState<StubLinkType>(loadState: .payloadRequested(stubPayload),
                                                                     currentNode: StubNode.nodeBox)

                        result = RouterReducer.reduce(action: action,
                                                      currentState: currentState)
                    }

                    it("returns a state with currentNode equal to .setCurrentCoordinator's value, and otherwise unchanged") {
                        expect(result) == RouterState<StubLinkType>(loadState: .payloadRequested(stubPayload),
                                                                    currentNode: OtherStubNode.nodeBox)
                    }
                }

                context("and the loadState before reducing is .waitingForPayloadToBeCleared") {
                    beforeEach {
                        let action = RouterAction<StubLinkType>.setCurrentCoordinator(OtherStubNode.nodeBox)
                        let currentState = RouterState<StubLinkType>(
                            loadState: .waitingForPayloadToBeCleared(stubPayload),
                            currentNode: StubNode.nodeBox
                        )

                        result = RouterReducer.reduce(action: action,
                                                      currentState: currentState)
                    }

                    it("returns a state with currentNode equal to .setCurrentCoordinator's value, and otherwise unchanged") {
                        expect(result) == RouterState<StubLinkType>(
                            loadState: .waitingForPayloadToBeCleared(stubPayload),
                            currentNode: OtherStubNode.nodeBox
                        )
                    }
                }

                context("and the loadState before reducing is .navigatingToDestination") {

                    context("and .setCurrentCoordinator's value is not equal to .navigatingToDestination's") {
                        beforeEach {
                            let action = RouterAction<StubLinkType>.setCurrentCoordinator(OtherStubNode.nodeBox)
                            let currentState = RouterState<StubLinkType>(
                                loadState: .navigatingToDestination(StubDestinationNode.destinationNodeBox,
                                                                    payload: stubPayload),
                                currentNode: StubNode.nodeBox
                            )

                            result = RouterReducer.reduce(action: action,
                                                          currentState: currentState)
                        }

                        it("returns a state with .setCurrentCoordinator's value, and otherwise unchanged") {
                            expect(result) == RouterState<StubLinkType>(
                                loadState: .navigatingToDestination(StubDestinationNode.destinationNodeBox,
                                                                    payload: stubPayload),
                                currentNode: OtherStubNode.nodeBox
                            )
                        }
                    }

                    context("else when the loadState before reducing has a non-nil payload") {
                        beforeEach {
                            let action = RouterAction<StubLinkType>.setCurrentCoordinator(StubDestinationNode.nodeBox)
                            let currentState = RouterState<StubLinkType>(
                                loadState: .navigatingToDestination(StubDestinationNode.destinationNodeBox,
                                                                    payload: stubPayload),
                                currentNode: StubNode.nodeBox
                            )

                            result = RouterReducer.reduce(action: action,
                                                          currentState: currentState)
                        }

                        it("returns a state with .setCurrentCoordinator's value, and loadState == .waitingForPayloadToBeCleared") {
                            expect(result) == RouterState<StubLinkType>(
                                loadState: .waitingForPayloadToBeCleared(stubPayload),
                                currentNode: StubDestinationNode.nodeBox
                            )
                        }
                    }

                    context("else when the loadState before reducing has a nil payload") {
                        beforeEach {
                            let action = RouterAction<StubLinkType>.setCurrentCoordinator(StubDestinationNode.nodeBox)
                            let currentState = RouterState<StubLinkType>(
                                loadState: .navigatingToDestination(StubDestinationNode.destinationNodeBox,
                                                                    payload: nil),
                                currentNode: StubNode.nodeBox
                            )

                            result = RouterReducer.reduce(action: action,
                                                          currentState: currentState)
                        }

                        it("returns a state with .setCurrentCoordinator's value, and loadState == .idle") {
                            expect(result) == RouterState<StubLinkType>(
                                loadState: .idle,
                                currentNode: StubDestinationNode.nodeBox
                            )
                        }
                    }

                }

            }

            context("else when the action is RouterAction.setDestinationCoordinator") {

                beforeEach {
                    let action = RouterAction.setDestinationCoordinator(StubDestinationNode.destinationNodeBox,
                                                                        payload: stubPayload)
                    let currentState = RouterState<StubLinkType>(currentNode: StubNode.nodeBox)

                    result = RouterReducer.reduce(action: action,
                                                  currentState: currentState)
                }

                it("returns a state with loadState == .navigatingToDestination, and otherwise unchanged") {
                    expect(result) == RouterState<StubLinkType>(
                        loadState: .navigatingToDestination(StubDestinationNode.destinationNodeBox,
                                                            payload: stubPayload),
                        currentNode: StubNode.nodeBox
                    )
                }
            }

            context("else when the action is RouterAction.requestLink") {

                beforeEach {
                    let currentState = RouterState<StubLinkType>(currentNode: StubNode.nodeBox)
                    result = RouterReducer.reduce(action: RouterAction.requestLink(stubPayload),
                                                  currentState: currentState)
                }

                it("returns a state with loadState == .payloadRequested, and otherwise unchanged") {
                    expect(result) == RouterState<StubLinkType>(loadState: .payloadRequested(stubPayload),
                                                                currentNode: StubNode.nodeBox)
                }

            }

            context("else when the action is RouterAction.clearLink") {

                beforeEach {
                    let currentState = RouterState<StubLinkType>(currentNode: StubNode.nodeBox)
                    result = RouterReducer.reduce(action: RouterAction<StubLinkType>.clearLink,
                                                  currentState: currentState)
                }

                it("returns a state with loadState == .idle, and otherwise unchanged") {
                    expect(result) == RouterState<StubLinkType>(loadState: .idle,
                                                                currentNode: StubNode.nodeBox)
                }
            }

        }

    }

}
