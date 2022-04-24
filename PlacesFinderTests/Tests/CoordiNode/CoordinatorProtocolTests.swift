//
//  CoordinatorProtocolTests.swift
//  PlacesFinderTests
//
//  Copyright (c) 2020 Justin Peckner
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

            var result: AppAction?

            beforeEach {
                result = StubSettingsCoordinator().requestLinkTypeAction(stubLinkType)
            }

            it("returns AppRouterAction.requestLink, containing the passed link") {
                expect(result) == .router(.requestLink(stubLinkType))
            }

        }

    }

}
