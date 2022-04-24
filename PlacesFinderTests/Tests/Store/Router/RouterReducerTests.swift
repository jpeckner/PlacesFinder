//
//  RouterReducerTests.swift
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

        let stubLinkType = StubLinkType()

        describe("reduce") {

            var result: RouterState<StubLinkType>!

            context("when the action is not a RouterAction") {
                let currentState = RouterState<StubLinkType>(currentNode: StubNode.nodeBox)

                beforeEach {
                    let action: AppAction = .appSkin(.startLoad)
                    result = RouterReducer.reduce(action: action,
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

                        result = RouterReducer.reduce(routerAction: action,
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
                        let currentState = RouterState<StubLinkType>(loadState: .payloadRequested(stubLinkType),
                                                                     currentNode: StubNode.nodeBox)

                        result = RouterReducer.reduce(routerAction: action,
                                                      currentState: currentState)
                    }

                    it("returns a state with currentNode equal to .setCurrentCoordinator's value, and otherwise unchanged") {
                        expect(result) == RouterState<StubLinkType>(loadState: .payloadRequested(stubLinkType),
                                                                    currentNode: OtherStubNode.nodeBox)
                    }
                }

                context("and the loadState before reducing is .waitingForPayloadToBeCleared") {
                    beforeEach {
                        let action = RouterAction<StubLinkType>.setCurrentCoordinator(OtherStubNode.nodeBox)
                        let currentState = RouterState<StubLinkType>(
                            loadState: .waitingForPayloadToBeCleared(stubLinkType),
                            currentNode: StubNode.nodeBox
                        )

                        result = RouterReducer.reduce(routerAction: action,
                                                      currentState: currentState)
                    }

                    it("returns a state with currentNode equal to .setCurrentCoordinator's value, and otherwise unchanged") {
                        expect(result) == RouterState<StubLinkType>(
                            loadState: .waitingForPayloadToBeCleared(stubLinkType),
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
                                                                    linkType: stubLinkType),
                                currentNode: StubNode.nodeBox
                            )

                            result = RouterReducer.reduce(routerAction: action,
                                                          currentState: currentState)
                        }

                        it("returns a state with .setCurrentCoordinator's value, and otherwise unchanged") {
                            expect(result) == RouterState<StubLinkType>(
                                loadState: .navigatingToDestination(StubDestinationNode.destinationNodeBox,
                                                                    linkType: stubLinkType),
                                currentNode: OtherStubNode.nodeBox
                            )
                        }
                    }

                    context("else when the loadState before reducing has a non-nil payload") {
                        beforeEach {
                            let action = RouterAction<StubLinkType>.setCurrentCoordinator(StubDestinationNode.nodeBox)
                            let currentState = RouterState<StubLinkType>(
                                loadState: .navigatingToDestination(StubDestinationNode.destinationNodeBox,
                                                                    linkType: stubLinkType),
                                currentNode: StubNode.nodeBox
                            )

                            result = RouterReducer.reduce(routerAction: action,
                                                          currentState: currentState)
                        }

                        it("returns a state with .setCurrentCoordinator's value, and loadState == .waitingForPayloadToBeCleared") {
                            expect(result) == RouterState<StubLinkType>(
                                loadState: .waitingForPayloadToBeCleared(stubLinkType),
                                currentNode: StubDestinationNode.nodeBox
                            )
                        }
                    }

                    context("else when the loadState before reducing has a nil payload") {
                        beforeEach {
                            let action = RouterAction<StubLinkType>.setCurrentCoordinator(StubDestinationNode.nodeBox)
                            let currentState = RouterState<StubLinkType>(
                                loadState: .navigatingToDestination(StubDestinationNode.destinationNodeBox,
                                                                    linkType: nil),
                                currentNode: StubNode.nodeBox
                            )

                            result = RouterReducer.reduce(routerAction: action,
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
                                                                        payload: stubLinkType)
                    let currentState = RouterState<StubLinkType>(currentNode: StubNode.nodeBox)

                    result = RouterReducer.reduce(routerAction: action,
                                                  currentState: currentState)
                }

                it("returns a state with loadState == .navigatingToDestination, and otherwise unchanged") {
                    expect(result) == RouterState<StubLinkType>(
                        loadState: .navigatingToDestination(StubDestinationNode.destinationNodeBox,
                                                            linkType: stubLinkType),
                        currentNode: StubNode.nodeBox
                    )
                }
            }

            context("else when the action is RouterAction.requestLink") {

                beforeEach {
                    let currentState = RouterState<StubLinkType>(currentNode: StubNode.nodeBox)
                    result = RouterReducer.reduce(routerAction: RouterAction.requestLink(stubLinkType),
                                                  currentState: currentState)
                }

                it("returns a state with loadState == .payloadRequested, and otherwise unchanged") {
                    expect(result) == RouterState<StubLinkType>(loadState: .payloadRequested(stubLinkType),
                                                                currentNode: StubNode.nodeBox)
                }

            }

            context("else when the action is RouterAction.clearLink") {

                beforeEach {
                    let currentState = RouterState<StubLinkType>(currentNode: StubNode.nodeBox)
                    result = RouterReducer.reduce(routerAction: RouterAction<StubLinkType>.clearLink,
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
