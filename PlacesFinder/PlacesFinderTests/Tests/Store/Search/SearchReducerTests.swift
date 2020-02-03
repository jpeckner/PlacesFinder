//
//  SearchReducerTests.swift
//  PlacesFinderTests
//
//  Created by Justin Peckner.
//  Copyright © 2019 Justin Peckner. All rights reserved.
//

import Nimble
#if DEBUG
@testable import PlacesFinder
#endif
import Quick
import Shared
import SharedTestComponents
import SwiftDuxTestComponents

class SearchReducerTests: QuickSpec {

    // swiftlint:disable function_body_length
    // swiftlint:disable implicitly_unwrapped_optional
    // swiftlint:disable line_length
    override func spec() {

        describe("reduce") {

            let stubParams = PlaceLookupParams.stubValue()
            let stubSubmittedParams = SearchSubmittedParams(keywords: stubParams.keywords)
            let stubDetailsViewModel = SearchEntityModel.stubValue()
            let stubEntities = NonEmptyArray(with: SearchEntityModel.stubValue())
            let stubTokenContainer = PlaceLookupTokenAttemptsContainer.stubValue()

            var result: SearchState!

            context("when the action is not a SearchAction") {
                let currentState = SearchState(loadState: .idle,
                                               detailedEntity: stubDetailsViewModel)

                beforeEach {
                    result = SearchReducer.reduce(action: StubAction.genericAction,
                                                  currentState: currentState)
                }

                it("returns the current state") {
                    expect(result) == currentState
                }
            }

            context("else when the action is SearchAction.locationRequested") {
                let currentState = SearchState(loadState: .idle,
                                               detailedEntity: stubDetailsViewModel)

                beforeEach {
                    result = SearchReducer.reduce(action: SearchAction.locationRequested(stubSubmittedParams),
                                                  currentState: currentState)
                }

                it("returns a state with loadState == .locationRequested, detailedEntity == nil, and all other fields unchanged") {
                    expect(result) == SearchState(loadState: .locationRequested(stubSubmittedParams),
                                                  detailedEntity: nil)
                }
            }

            context("else when the action is SearchAction.initialPageRequested") {
                let currentState = SearchState(loadState: .idle,
                                               detailedEntity: stubDetailsViewModel)

                beforeEach {
                    result = SearchReducer.reduce(action: SearchAction.initialPageRequested(stubSubmittedParams),
                                                  currentState: currentState)
                }

                it("returns a state with loadState == .initialPageRequested, detailedEntity == nil, and all other fields unchanged") {
                    expect(result) == SearchState(loadState: .initialPageRequested(stubSubmittedParams),
                                                  detailedEntity: nil)
                }
            }

            context("else when the action is SearchAction.noResultsFound") {
                let currentState = SearchState(loadState: .idle,
                                               detailedEntity: stubDetailsViewModel)

                beforeEach {
                    result = SearchReducer.reduce(action: SearchAction.noResultsFound(stubSubmittedParams),
                                                  currentState: currentState)
                }

                it("returns a state with loadState == .noResultsFound, detailedEntity == nil, and all other fields unchanged") {
                    expect(result) == SearchState(loadState: .noResultsFound(stubSubmittedParams),
                                                  detailedEntity: nil)
                }
            }

            context("else when the action is SearchAction.subsequentRequest") {

                func verifyResult(expectedPageState: SearchPageState,
                                  expectedEntities: NonEmptyArray<SearchEntityModel>,
                                  expectedToken: PlaceLookupTokenAttemptsContainer) {
                    guard case let .pagesReceived(submittedParams,
                                                  pageState,
                                                  entities,
                                                  nextRequestToken) = result.loadState
                    else {
                        fail("Unexpected value: \(result.loadState)")
                        return
                    }

                    expect(submittedParams) == stubSubmittedParams
                    expect(pageState) == expectedPageState
                    expect(entities) == expectedEntities
                    expect(nextRequestToken) == expectedToken
                    expect(result.detailedEntity) == stubDetailsViewModel
                }

                context("and the current loadState is not .pagesReceived") {
                    let currentState = SearchState(loadState: .idle,
                                                   detailedEntity: stubDetailsViewModel)

                    beforeEach {
                        let action = SearchAction.subsequentRequest(
                            stubSubmittedParams,
                            pageAction: .success,
                            allEntities: stubEntities,
                            nextRequestToken: stubTokenContainer
                        )
                        result = SearchReducer.reduce(action: action,
                                                      currentState: currentState)
                    }

                    it("returns loadState == .pagesReceived, pageState == .inProgress, and otherwise unchanged") {
                        verifyResult(expectedPageState: .inProgress,
                                     expectedEntities: stubEntities,
                                     expectedToken: stubTokenContainer)
                    }
                }

                context("else and the pageAction is .inProgress") {
                    let currentLoadState = SearchLoadState.pagesReceived(
                        stubSubmittedParams,
                        pageState: .success,
                        allEntities: stubEntities,
                        nextRequestToken: stubTokenContainer
                    )
                    let currentState = SearchState(loadState: currentLoadState,
                                                   detailedEntity: stubDetailsViewModel)

                    beforeEach {
                        let action = SearchAction.subsequentRequest(
                            stubSubmittedParams,
                            pageAction: .inProgress,
                            allEntities: stubEntities,
                            nextRequestToken: stubTokenContainer
                        )
                        result = SearchReducer.reduce(action: action,
                                                      currentState: currentState)
                    }

                    it("returns loadState == .pagesReceived, pageState == .inProgress, and otherwise unchanged") {
                        verifyResult(expectedPageState: .inProgress,
                                     expectedEntities: stubEntities,
                                     expectedToken: stubTokenContainer)
                    }
                }

                context("and the pageAction is .success") {
                    let currentLoadState = SearchLoadState.pagesReceived(
                        stubSubmittedParams,
                        pageState: .success,
                        allEntities: stubEntities,
                        nextRequestToken: stubTokenContainer
                    )
                    let currentState = SearchState(loadState: currentLoadState,
                                                   detailedEntity: stubDetailsViewModel)

                    beforeEach {
                        let action = SearchAction.subsequentRequest(
                            stubSubmittedParams,
                            pageAction: .success,
                            allEntities: stubEntities,
                            nextRequestToken: stubTokenContainer
                        )
                        result = SearchReducer.reduce(action: action,
                                                      currentState: currentState)
                    }

                    it("returns loadState == .pagesReceived, pageState == .success, and otherwise unchanged") {
                        verifyResult(expectedPageState: .success,
                                     expectedEntities: stubEntities,
                                     expectedToken: stubTokenContainer)
                    }
                }

                context("and the pageAction is .failure") {
                    let currentLoadState = SearchLoadState.pagesReceived(
                        stubSubmittedParams,
                        pageState: .success,
                        allEntities: stubEntities,
                        nextRequestToken: stubTokenContainer
                    )
                    let currentState = SearchState(loadState: currentLoadState,
                                                   detailedEntity: stubDetailsViewModel)
                    let underlyingError = IgnoredEquatable<Error>(StubError.plainError)
                    let pageError = SearchPageRequestError.cannotRetryRequest(underlyingError: underlyingError)

                    beforeEach {
                        let action = SearchAction.subsequentRequest(
                            stubSubmittedParams,
                            pageAction: .failure(pageError),
                            allEntities: stubEntities,
                            nextRequestToken: stubTokenContainer
                        )
                        result = SearchReducer.reduce(action: action,
                                                      currentState: currentState)
                    }

                    it("returns loadState == .pagesReceived, pageState == .failure, and otherwise unchanged") {
                        verifyResult(expectedPageState: .failure(pageError),
                                     expectedEntities: stubEntities,
                                     expectedToken: stubTokenContainer)
                    }
                }
            }

            context("else when the action is SearchAction.detailedEntity") {
                let currentState = SearchState(loadState: .idle,
                                               detailedEntity: nil)

                beforeEach {
                    result = SearchReducer.reduce(action: SearchAction.detailedEntity(stubDetailsViewModel),
                                                  currentState: currentState)
                }

                it("returns a state with detailedEntity equal to the action's arg, and all other fields unchanged") {
                    expect(result) == SearchState(loadState: .idle,
                                                  detailedEntity: stubDetailsViewModel)
                }
            }

            context("else when the action is SearchAction.removeDetailedEntity") {
                let currentState = SearchState(loadState: .idle,
                                               detailedEntity: stubDetailsViewModel)

                beforeEach {
                    result = SearchReducer.reduce(action: SearchAction.removeDetailedEntity,
                                                  currentState: currentState)
                }

                it("returns a state with detailedEntity equal to nil, and all other fields unchanged") {
                    expect(result) == SearchState(loadState: .idle,
                                                  detailedEntity: nil)
                }
            }

            context("else when the action is SearchAction.initialPageReceived") {
                let currentState = SearchState(loadState: .idle,
                                               detailedEntity: stubDetailsViewModel)

                beforeEach {
                    let action = SearchAction.failure(stubSubmittedParams,
                                                      underlyingError: IgnoredEquatable(StubError.plainError))
                    result = SearchReducer.reduce(action: action,
                                                  currentState: currentState)
                }

                it("returns a state with loadState == .failure, detailedEntity == nil, and all other fields unchanged") {
                    expect(result) == SearchState(
                        loadState: .failure(stubSubmittedParams,
                                            underlyingError: IgnoredEquatable(StubError.plainError)),
                        detailedEntity: nil
                    )
                }
            }

        }

    }

}
