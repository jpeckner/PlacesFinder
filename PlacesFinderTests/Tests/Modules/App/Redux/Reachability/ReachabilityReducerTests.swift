//
//  ReachabilityReducerTests.swift
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

import Nimble
import Quick
import Shared
import SwiftDuxTestComponents

class ReachabilityReducerTests: QuickSpec {

    // swiftlint:disable implicitly_unwrapped_optional
    override func spec() {

        describe("reduce") {

            var result: ReachabilityState!

            context("when the action is not a ReachabilityAction") {
                let currentState = ReachabilityState(status: .unreachable)

                beforeEach {
                    let action: AppAction = .appSkin(.startLoad)
                    result = ReachabilityReducer.reduce(action: action,
                                                        currentState: currentState)
                }

                it("returns the current state") {
                    expect(result) == currentState
                }
            }

            context("else when the action is ReachabilityAction.unreachable") {
                beforeEach {
                    let action: AppAction = .reachability(.unreachable)
                    let currentState = ReachabilityState(status: .reachable)
                    result = ReachabilityReducer.reduce(action: action,
                                                        currentState: currentState)
                }

                it("returns a state with status == .unreachable") {
                    expect(result) == ReachabilityState(status: .unreachable)
                }
            }

            context("else when the action is ReachabilityAction.reachable") {

                let currentState = ReachabilityState(status: .unreachable)

                beforeEach {
                    let action: AppAction = .reachability(.reachable)
                    result = ReachabilityReducer.reduce(
                        action: action,
                        currentState: currentState
                    )
                }

                it("returns a state with status == .reachable") {
                    expect(result) == ReachabilityState(status: .reachable)
                }

            }

        }

    }

}
