//
//  SearchActivityStateTests.swift
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

import CoreLocation
import Nimble
import Quick
import Shared
import SharedTestComponents
import SwiftDux

// swiftlint:disable blanket_disable_command
// swiftlint:disable function_body_length
class SearchActivityStateTests: QuickSpec {

    override func spec() {

        let stubSearchParams = SearchParams.stubValue()
        let stubSearchInputParams = SearchInputParams(params: stubSearchParams,
                                                      barState: .isShowing(isEditing: false))
        let stubEntities = NonEmptyArray(with: SearchEntityModel.stubValue())
        let stubTokenContainer = PlaceLookupTokenAttemptsContainer.stubValue()

        describe("entities") {

            var result: NonEmptyArray<SearchEntityModel>?

            context("when state.loadState == .idle") {
                beforeEach {
                    let state = Search.ActivityState(
                        loadState: .idle,
                        inputParams: stubSearchInputParams,
                        detailedEntity: nil
                    )
                    result = state.entities
                }

                it("returns nil") {
                    expect(result) == nil
                }
            }

            context("else when state.loadState == .locationRequested") {
                beforeEach {
                    let state = Search.ActivityState(
                        loadState: .locationRequested(stubSearchParams),
                        inputParams: stubSearchInputParams,
                        detailedEntity: nil
                    )
                    result = state.entities
                }

                it("returns nil") {
                    expect(result) == nil
                }
            }

            context("else when state.loadState == .initialPageRequested") {
                beforeEach {
                    let state = Search.ActivityState(
                        loadState: .initialPageRequested(stubSearchParams),
                        inputParams: stubSearchInputParams,
                        detailedEntity: nil
                    )
                    result = state.entities
                }

                it("returns nil") {
                    expect(result) == nil
                }
            }

            context("else when state.loadState == .noResultsFound") {
                beforeEach {
                    let state = Search.ActivityState(
                        loadState: .noResultsFound(stubSearchParams),
                        inputParams: stubSearchInputParams,
                        detailedEntity: nil
                    )
                    result = state.entities
                }

                it("returns nil") {
                    expect(result) == nil
                }
            }

            context("else when state.loadState == .pagesReceived") {
                beforeEach {
                    let state = Search.ActivityState(
                        loadState: Search.LoadState.pagesReceived(
                            params: stubSearchParams,
                            pageState: .success,
                            numPagesReceived: 1,
                            allEntities: stubEntities,
                            nextRequestToken: stubTokenContainer
                        ),
                        inputParams: stubSearchInputParams,
                        detailedEntity: nil
                    )

                    result = state.entities
                }

                it("returns the SearchParams") {
                    expect(result) == stubEntities
                }
            }

            context("else when state.loadState == .failure") {
                beforeEach {
                    let underlyingError = IgnoredEquatable<Error>(StubError.plainError)
                    let state = Search.ActivityState(
                        loadState: .failure(stubSearchParams, underlyingError: underlyingError),
                        inputParams: stubSearchInputParams,
                        detailedEntity: nil
                    )
                    result = state.entities
                }

                it("returns nil") {
                    expect(result) == nil
                }
            }

        }

    }

}
// swiftlint:enable blanket_disable_command
