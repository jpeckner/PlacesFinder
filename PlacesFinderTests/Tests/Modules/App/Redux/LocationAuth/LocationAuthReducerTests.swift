//
//  LocationAuthReducerTests.swift
//  PlacesFinderTests
//
//  Copyright (c) 2018 Justin Peckner
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

// swiftlint:disable blanket_disable_command
// swiftlint:disable implicitly_unwrapped_optional
class LocationAuthReducerTests: QuickSpec {

    override func spec() {

        describe("LocationAuthReducer.reduce") {

            var result: LocationAuthState!

            context("when the action is not a LocationAuthAction") {
                let currentState = LocationAuthState(authStatus: .locationServicesEnabled)

                beforeEach {
                    let action: AppAction = .appSkin(.startLoad)
                    result = LocationAuthReducer.reduce(action: action,
                                                        currentState: currentState)
                }

                it("returns the current state") {
                    expect(result) == currentState
                }
            }

            context("when the action is LocationAuthAction.notDetermined") {
                beforeEach {
                    let action: AppAction = .locationAuth(.notDetermined)
                    let currentState = LocationAuthState(authStatus: .locationServicesDisabled)
                    result = LocationAuthReducer.reduce(action: action,
                                                        currentState: currentState)
                }

                it("returns the .notDetermined state") {
                    expect(result) == LocationAuthState(authStatus: .notDetermined)
                }
            }

            context("when the action is LocationAuthAction.locationServicesEnabled") {
                beforeEach {
                    let action: AppAction = .locationAuth(.locationServicesEnabled)
                    let currentState = LocationAuthState(authStatus: .locationServicesDisabled)
                    result = LocationAuthReducer.reduce(action: action,
                                                        currentState: currentState)
                }

                it("returns the .locationServicesEnabled state") {
                    expect(result) == LocationAuthState(authStatus: .locationServicesEnabled)
                }
            }

            context("when the action is LocationAuthAction.locationServicesDisabled") {
                beforeEach {
                    let action: AppAction = .locationAuth(.locationServicesDisabled)
                    let currentState = LocationAuthState(authStatus: .locationServicesEnabled)
                    result = LocationAuthReducer.reduce(action: action,
                                                        currentState: currentState)
                }

                it("returns the .locationServicesDisabled state") {
                    expect(result) == LocationAuthState(authStatus: .locationServicesDisabled)
                }
            }

        }

    }

}
// swiftlint:enable blanket_disable_command
