//
//  SearchPreferencesReducerTests.swift
//  PlacesFinderTests
//
//  Created by Justin Peckner.
//  Copyright © 2019 Justin Peckner. All rights reserved.
//

import Nimble
import Quick
import Shared
import SwiftDuxTestComponents

class SearchPreferencesReducerTests: QuickSpec {

    // swiftlint:disable implicitly_unwrapped_optional
    override func spec() {

        describe("reduce") {

            var result: SearchPreferencesState!

            context("when the action is not a SearchPreferencesAction") {
                let currentState = SearchPreferencesState(distance: .imperial(.twentyMiles),
                                                          sorting: .rating)

                beforeEach {
                    result = SearchPreferencesReducer.reduce(action: StubAction.genericAction,
                                                             currentState: currentState)
                }

                it("returns the current state") {
                    expect(result) == currentState
                }
            }

            context("else when the action is SearchPreferencesAction.setDistance()") {
                let currentState = SearchPreferencesState(distance: .imperial(.twentyMiles),
                                                          sorting: .rating)

                beforeEach {
                    result = SearchPreferencesReducer.reduce(
                        action: SearchPreferencesAction.setDistance(.imperial(.oneMile)),
                        currentState: currentState
                    )
                }

                it("returns a state with the updated distance, and all other fields unchanged") {
                    expect(result) == SearchPreferencesState(distance: .imperial(.oneMile),
                                                             sorting: .rating)
                }
            }

            context("else when the action is SearchPreferencesAction.setSorting()") {
                let currentState = SearchPreferencesState(distance: .imperial(.twentyMiles),
                                                          sorting: .rating)

                beforeEach {
                    result = SearchPreferencesReducer.reduce(
                        action: SearchPreferencesAction.setSorting(.bestMatch),
                        currentState: currentState
                    )
                }

                it("returns a state with the updated distance, and all other fields unchanged") {
                    expect(result) == SearchPreferencesState(distance: .imperial(.twentyMiles),
                                                             sorting: .bestMatch)
                }
            }

        }

    }

}
