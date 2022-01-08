//
//  SearchPreferencesReducerTests.swift
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

class SearchPreferencesReducerTests: QuickSpec {

    // swiftlint:disable implicitly_unwrapped_optional
    override func spec() {

        describe("reduce") {

            var result: SearchPreferencesState!

            context("when the action is not a SearchPreferencesAction") {
                let currentState = SearchPreferencesState(
                    stored: StoredSearchPreferences(
                        distance: .imperial(.twentyMiles),
                        sorting: .rating
                    )
                )

                beforeEach {
                    result = SearchPreferencesReducer.reduce(action: StubAction.genericAction,
                                                             currentState: currentState)
                }

                it("returns the current state") {
                    expect(result) == currentState
                }
            }

            context("else when the action is SearchPreferencesAction.setDistance()") {
                let currentState = SearchPreferencesState(
                    stored: StoredSearchPreferences(
                        distance: .imperial(.twentyMiles),
                        sorting: .rating
                    )
                )

                beforeEach {
                    result = SearchPreferencesReducer.reduce(
                        action: SearchPreferencesAction.setDistance(.imperial(.oneMile)),
                        currentState: currentState
                    )
                }

                it("returns a state with the updated distance, and all other fields unchanged") {
                    expect(result) == SearchPreferencesState(
                        stored: StoredSearchPreferences(
                            distance: .imperial(.oneMile),
                            sorting: .rating
                        )
                    )
                }
            }

            context("else when the action is SearchPreferencesAction.setSorting()") {
                let currentState = SearchPreferencesState(
                    stored: StoredSearchPreferences(
                        distance: .imperial(.twentyMiles),
                        sorting: .rating
                    )
                )

                beforeEach {
                    result = SearchPreferencesReducer.reduce(
                        action: SearchPreferencesAction.setSorting(.bestMatch),
                        currentState: currentState
                    )
                }

                it("returns a state with the updated distance, and all other fields unchanged") {
                    expect(result) == SearchPreferencesState(
                        stored: StoredSearchPreferences(
                            distance: .imperial(.twentyMiles),
                            sorting: .bestMatch
                        )
                    )
                }
            }

        }

    }

}
