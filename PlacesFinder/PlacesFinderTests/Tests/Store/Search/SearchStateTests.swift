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

        let stubSubmittedParams = SearchSubmittedParams.stubValue()
        let stubEntities = NonEmptyArray(with: SearchEntityModel.stubValue())
        let stubTokenContainer = PlaceLookupTokenAttemptsContainer.stubValue()

        describe("submittedParams") {

            var result: SearchSubmittedParams?

            context("when state.loadState == .idle") {
                beforeEach {
                    let state = SearchState(loadState: .idle,
                                            detailedEntity: nil)
                    result = state.submittedParams
                }

                it("returns nil") {
                    expect(result).to(beNil())
                }
            }

            context("else when state.loadState == .locationRequested") {
                beforeEach {
                    let state = SearchState(loadState: .locationRequested(stubSubmittedParams),
                                            detailedEntity: nil)
                    result = state.submittedParams
                }

                it("returns the SearchSubmittedParams") {
                    expect(result) == stubSubmittedParams
                }
            }

            context("else when state.loadState == .initialPageRequested") {
                beforeEach {
                    let state = SearchState(loadState: .initialPageRequested(stubSubmittedParams),
                                            detailedEntity: nil)
                    result = state.submittedParams
                }

                it("returns the SearchSubmittedParams") {
                    expect(result) == stubSubmittedParams
                }
            }

            context("else when state.loadState == .noResultsFound") {
                beforeEach {
                    let state = SearchState(loadState: .noResultsFound(stubSubmittedParams),
                                            detailedEntity: nil)
                    result = state.submittedParams
                }

                it("returns the SearchSubmittedParams") {
                    expect(result) == stubSubmittedParams
                }
            }

            context("else when state.loadState == .pagesReceived") {
                beforeEach {
                    let state = SearchState(
                        loadState: SearchLoadState.pagesReceived(
                            stubSubmittedParams,
                            pageState: .success,
                            allEntities: stubEntities,
                            nextRequestToken: stubTokenContainer
                        ),
                        detailedEntity: nil
                    )

                    result = state.submittedParams
                }

                it("returns the SearchSubmittedParams") {
                    expect(result) == stubSubmittedParams
                }
            }

            context("else when state.loadState == .failure") {
                beforeEach {
                    let underlyingError = IgnoredEquatable<Error>(StubError.plainError)
                    let state = SearchState(loadState: .failure(stubSubmittedParams, underlyingError: underlyingError),
                                            detailedEntity: nil)
                    result = state.submittedParams
                }

                it("returns the SearchSubmittedParams") {
                    expect(result) == stubSubmittedParams
                }
            }

        }

        describe("entities") {

            var result: NonEmptyArray<SearchEntityModel>?

            context("when state.loadState == .idle") {
                beforeEach {
                    let state = SearchState(loadState: .idle,
                                            detailedEntity: nil)
                    result = state.entities
                }

                it("returns nil") {
                    expect(result).to(beNil())
                }
            }

            context("else when state.loadState == .locationRequested") {
                beforeEach {
                    let state = SearchState(loadState: .locationRequested(stubSubmittedParams),
                                            detailedEntity: nil)
                    result = state.entities
                }

                it("returns nil") {
                    expect(result).to(beNil())
                }
            }

            context("else when state.loadState == .initialPageRequested") {
                beforeEach {
                    let state = SearchState(loadState: .initialPageRequested(stubSubmittedParams),
                                            detailedEntity: nil)
                    result = state.entities
                }

                it("returns nil") {
                    expect(result).to(beNil())
                }
            }

            context("else when state.loadState == .noResultsFound") {
                beforeEach {
                    let state = SearchState(loadState: .noResultsFound(stubSubmittedParams),
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
                            stubSubmittedParams,
                            pageState: .success,
                            allEntities: stubEntities,
                            nextRequestToken: stubTokenContainer
                        ),
                        detailedEntity: nil
                    )

                    result = state.entities
                }

                it("returns the SearchSubmittedParams") {
                    expect(result) == stubEntities
                }
            }

            context("else when state.loadState == .failure") {
                beforeEach {
                    let underlyingError = IgnoredEquatable<Error>(StubError.plainError)
                    let state = SearchState(loadState: .failure(stubSubmittedParams, underlyingError: underlyingError),
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
