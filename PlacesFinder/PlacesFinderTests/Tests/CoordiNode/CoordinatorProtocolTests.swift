//
//  CoordinatorProtocolTests.swift
//  PlacesFinderTests
//
//  Created by Justin Peckner.
//  Copyright © 2020 Justin Peckner. All rights reserved.
//

import CoordiNode
import Nimble
import Quick
import SwiftDux

class CoordinatorProtocolTests: QuickSpec {

    private class StubSearchCoordinator: CoordinatorProtocol {
        static var nodeBox: NodeBox {
            return NodeBox(SearchCoordinatorNode.self)
        }
    }

    private class StubSettingsCoordinator: CoordinatorProtocol {
        static var nodeBox: NodeBox {
            return NodeBox(SettingsCoordinatorNode.self)
        }
    }

    // swiftlint:disable implicitly_unwrapped_optional
    override func spec() {

        describe("isCurrentCoordinator") {

            var result: Bool!

            context("when the state's current node is equal to sut's") {
                beforeEach {
                    let stubState = AppState.stubValue(
                        routerState: .init(currentNode: SearchCoordinatorNode.nodeBox)
                    )
                    result = StubSearchCoordinator().isCurrentCoordinator(stubState)
                }

                it("returns true") {
                    expect(result) == true
                }
            }

            context("else when the state's current node is not equal to sut's") {
                beforeEach {
                    let stubState = AppState.stubValue(
                        routerState: .init(currentNode: SettingsCoordinatorNode.nodeBox)
                    )
                    result = StubSearchCoordinator().isCurrentCoordinator(stubState)
                }

                it("returns false") {
                    expect(result) == false
                }
            }

        }

        describe("requestLinkTypeAction") {

            let stubLinkType: AppLinkType = .emptySearch(EmptySearchLinkPayload())

            var result: Action?

            context("when the link type's destination node is equal to sut's") {
                beforeEach {
                    result = StubSearchCoordinator().requestLinkTypeAction(stubLinkType)
                }

                it("returns nil") {
                    expect(result).to(beNil())
                }
            }

            context("else when the link type's destination node is not equal to sut's") {
                beforeEach {
                    result = StubSettingsCoordinator().requestLinkTypeAction(stubLinkType)
                }

                it("returns AppRouterAction.requestLink, containing the passed link") {
                    expect(result as? AppRouterAction) == .requestLink(stubLinkType)
                }
            }

        }

    }

}
