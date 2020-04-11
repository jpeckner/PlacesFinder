//
//  LocationAuthReducerTests.swift
//  PlacesFinderTests
//
//  Created by Justin Peckner.
//  Copyright © 2018 Justin Peckner. All rights reserved.
//

import Nimble
import Quick
import Shared
import SwiftDuxTestComponents

class LocationAuthReducerTests: QuickSpec {

    // swiftlint:disable implicitly_unwrapped_optional
    override func spec() {

        describe("LocationAuthReducer.reduce") {

            var result: LocationAuthState!

            context("when the action is not a LocationAuthAction") {
                let currentState = LocationAuthState(authStatus: .locationServicesEnabled)

                beforeEach {
                    result = LocationAuthReducer.reduce(action: StubAction.genericAction,
                                                        currentState: currentState)
                }

                it("returns the current state") {
                    expect(result) == currentState
                }
            }

            context("when the action is LocationAuthAction.notDetermined") {
                beforeEach {
                    let action = LocationAuthAction.notDetermined
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
                    let currentState = LocationAuthState(authStatus: .locationServicesDisabled)
                    result = LocationAuthReducer.reduce(action: LocationAuthAction.locationServicesEnabled,
                                                        currentState: currentState)
                }

                it("returns the .locationServicesEnabled state") {
                    expect(result) == LocationAuthState(authStatus: .locationServicesEnabled)
                }
            }

            context("when the action is LocationAuthAction.locationServicesDisabled") {
                beforeEach {
                    let currentState = LocationAuthState(authStatus: .locationServicesEnabled)
                    result = LocationAuthReducer.reduce(action: LocationAuthAction.locationServicesDisabled,
                                                        currentState: currentState)
                }

                it("returns the .locationServicesDisabled state") {
                    expect(result) == LocationAuthState(authStatus: .locationServicesDisabled)
                }
            }

        }

    }

}
