//
//  SearchStateTests.swift
//  PlacesFinderTests
//
//  Created by Justin Peckner.
//  Copyright © 2019 Justin Peckner. All rights reserved.
//

import CoreLocation
import Nimble
#if DEBUG
@testable import PlacesFinder
#endif
import Quick
import Shared
import SharedTestComponents
import SwiftDux

class SearchStateTests: QuickSpec {

    // swiftlint:disable function_body_length
    override func spec() {

        let stubSearchParams = SearchParams.stubValue()
        let stubSearchInputParams = SearchInputParams(params: stubSearchParams,
                                                      isEditing: false)
        let stubEntities = NonEmptyArray(with: SearchEntityModel.stubValue())
        let stubTokenContainer = PlaceLookupTokenAttemptsContainer.stubValue()

        describe("entities") {

            var result: NonEmptyArray<SearchEntityModel>?

            context("when state.loadState == .idle") {
                beforeEach {
                    let state = SearchState(loadState: .idle,
                                            inputParams: stubSearchInputParams,
                                            detailedEntity: nil)
                    result = state.entities
                }

                it("returns nil") {
                    expect(result).to(beNil())
                }
            }

            context("else when state.loadState == .locationRequested") {
                beforeEach {
                    let state = SearchState(loadState: .locationRequested(stubSearchParams),
                                            inputParams: stubSearchInputParams,
                                            detailedEntity: nil)
                    result = state.entities
                }

                it("returns nil") {
                    expect(result).to(beNil())
                }
            }

            context("else when state.loadState == .initialPageRequested") {
                beforeEach {
                    let state = SearchState(loadState: .initialPageRequested(stubSearchParams),
                                            inputParams: stubSearchInputParams,
                                            detailedEntity: nil)
                    result = state.entities
                }

                it("returns nil") {
                    expect(result).to(beNil())
                }
            }

            context("else when state.loadState == .noResultsFound") {
                beforeEach {
                    let state = SearchState(loadState: .noResultsFound(stubSearchParams),
                                            inputParams: stubSearchInputParams,
                                            detailedEntity: nil)
                    result = state.entities
                }

                it("returns nil") {
                    expect(result).to(beNil())
                }
            }

            context("else when state.loadState == .pagesReceived") {
                beforeEach {
                    let state = SearchState(
                        loadState: SearchLoadState.pagesReceived(
                            stubSearchParams,
                            pageState: .success,
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
                    let state = SearchState(loadState: .failure(stubSearchParams, underlyingError: underlyingError),
                                            inputParams: stubSearchInputParams,
                                            detailedEntity: nil)
                    result = state.entities
                }

                it("returns nil") {
                    expect(result).to(beNil())
                }
            }

        }

    }

}
