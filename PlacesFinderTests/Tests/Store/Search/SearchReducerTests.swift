//
//  SearchReducerTests.swift
//  PlacesFinderTests
//
//  Created by Justin Peckner.
//  Copyright © 2019 Justin Peckner. All rights reserved.
//

import Nimble
import Quick
import Shared
import SharedTestComponents
import SwiftDuxTestComponents

class SearchReducerTests: QuickSpec {

    // swiftlint:disable function_body_length
    // swiftlint:disable implicitly_unwrapped_optional
    override func spec() {

        describe("reduce") {

            let stubParams = PlaceLookupParams.stubValue()
            let stubSearchParams = SearchParams(keywords: stubParams.keywords)
            let stubSearchInputParams = SearchInputParams(params: stubSearchParams,
                                                          isEditing: false)
            let stubDetailsViewModel = SearchEntityModel.stubValue()
            let stubEntities = NonEmptyArray(with: SearchEntityModel.stubValue())
            let stubTokenContainer = PlaceLookupTokenAttemptsContainer.stubValue()

            var result: SearchState!

            context("when the action is not a SearchAction") {
                let currentState = SearchState(loadState: .idle,
                                               inputParams: stubSearchInputParams,
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
                                               inputParams: SearchInputParams(params: stubSearchParams,
                                                                              isEditing: true),
                                               detailedEntity: stubDetailsViewModel)

                beforeEach {
                    result = SearchReducer.reduce(action: SearchAction.locationRequested(stubSearchParams),
                                                  currentState: currentState)
                }

                it("returns the expected state") {
                    expect(result) == SearchState(loadState: .locationRequested(stubSearchParams),
                                                  inputParams: stubSearchInputParams,
                                                  detailedEntity: nil)
                }
            }

            context("else when the action is SearchAction.initialPageRequested") {
                let currentState = SearchState(loadState: .idle,
                                               inputParams: stubSearchInputParams,
                                               detailedEntity: stubDetailsViewModel)

                beforeEach {
                    result = SearchReducer.reduce(action: SearchAction.initialPageRequested(stubSearchParams),
                                                  currentState: currentState)
                }

                it("returns the expected state") {
                    expect(result) == SearchState(loadState: .initialPageRequested(stubSearchParams),
                                                  inputParams: stubSearchInputParams,
                                                  detailedEntity: nil)
                }
            }

            context("else when the action is SearchAction.noResultsFound") {
                let currentState = SearchState(loadState: .idle,
                                               inputParams: stubSearchInputParams,
                                               detailedEntity: stubDetailsViewModel)

                beforeEach {
                    result = SearchReducer.reduce(action: SearchAction.noResultsFound(stubSearchParams),
                                                  currentState: currentState)
                }

                it("returns the expected state") {
                    expect(result) == SearchState(loadState: .noResultsFound(stubSearchParams),
                                                  inputParams: stubSearchInputParams,
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

                    expect(submittedParams) == stubSearchParams
                    expect(pageState) == expectedPageState
                    expect(entities) == expectedEntities
                    expect(nextRequestToken) == expectedToken
                    expect(result.detailedEntity) == stubDetailsViewModel
                }

                context("and the current loadState is not .pagesReceived") {
                    let currentState = SearchState(loadState: .idle,
                                                   inputParams: stubSearchInputParams,
                                                   detailedEntity: stubDetailsViewModel)

                    beforeEach {
                        let action = SearchAction.subsequentRequest(
                            stubSearchParams,
                            pageAction: .success,
                            allEntities: stubEntities,
                            nextRequestToken: stubTokenContainer
                        )
                        result = SearchReducer.reduce(action: action,
                                                      currentState: currentState)
                    }

                    it("returns the expected state") {
                        verifyResult(expectedPageState: .inProgress,
                                     expectedEntities: stubEntities,
                                     expectedToken: stubTokenContainer)
                    }
                }

                context("else and the pageAction is .inProgress") {
                    let currentLoadState = SearchLoadState.pagesReceived(
                        stubSearchParams,
                        pageState: .success,
                        allEntities: stubEntities,
                        nextRequestToken: stubTokenContainer
                    )
                    let currentState = SearchState(loadState: currentLoadState,
                                                   inputParams: stubSearchInputParams,
                                                   detailedEntity: stubDetailsViewModel)

                    beforeEach {
                        let action = SearchAction.subsequentRequest(
                            stubSearchParams,
                            pageAction: .inProgress,
                            allEntities: stubEntities,
                            nextRequestToken: stubTokenContainer
                        )
                        result = SearchReducer.reduce(action: action,
                                                      currentState: currentState)
                    }

                    it("returns the expected state") {
                        verifyResult(expectedPageState: .inProgress,
                                     expectedEntities: stubEntities,
                                     expectedToken: stubTokenContainer)
                    }
                }

                context("and the pageAction is .success") {
                    let currentLoadState = SearchLoadState.pagesReceived(
                        stubSearchParams,
                        pageState: .success,
                        allEntities: stubEntities,
                        nextRequestToken: stubTokenContainer
                    )
                    let currentState = SearchState(loadState: currentLoadState,
                                                   inputParams: stubSearchInputParams,
                                                   detailedEntity: stubDetailsViewModel)

                    beforeEach {
                        let action = SearchAction.subsequentRequest(
                            stubSearchParams,
                            pageAction: .success,
                            allEntities: stubEntities,
                            nextRequestToken: stubTokenContainer
                        )
                        result = SearchReducer.reduce(action: action,
                                                      currentState: currentState)
                    }

                    it("returns the expected state") {
                        verifyResult(expectedPageState: .success,
                                     expectedEntities: stubEntities,
                                     expectedToken: stubTokenContainer)
                    }
                }

                context("and the pageAction is .failure") {
                    let currentLoadState = SearchLoadState.pagesReceived(
                        stubSearchParams,
                        pageState: .success,
                        allEntities: stubEntities,
                        nextRequestToken: stubTokenContainer
                    )
                    let currentState = SearchState(loadState: currentLoadState,
                                                   inputParams: stubSearchInputParams,
                                                   detailedEntity: stubDetailsViewModel)
                    let underlyingError = IgnoredEquatable<Error>(StubError.plainError)
                    let pageError = SearchPageRequestError.cannotRetryRequest(underlyingError: underlyingError)

                    beforeEach {
                        let action = SearchAction.subsequentRequest(
                            stubSearchParams,
                            pageAction: .failure(pageError),
                            allEntities: stubEntities,
                            nextRequestToken: stubTokenContainer
                        )
                        result = SearchReducer.reduce(action: action,
                                                      currentState: currentState)
                    }

                    it("returns the expected state") {
                        verifyResult(expectedPageState: .failure(pageError),
                                     expectedEntities: stubEntities,
                                     expectedToken: stubTokenContainer)
                    }
                }
            }

            context("else when the action is SearchAction.failure") {
                let currentState = SearchState(loadState: .idle,
                                               inputParams: stubSearchInputParams,
                                               detailedEntity: stubDetailsViewModel)

                beforeEach {
                    let action = SearchAction.failure(stubSearchParams,
                                                      underlyingError: IgnoredEquatable(StubError.plainError))
                    result = SearchReducer.reduce(action: action,
                                                  currentState: currentState)
                }

                it("returns the expected state") {
                    expect(result) == SearchState(
                        loadState: .failure(stubSearchParams,
                                            underlyingError: IgnoredEquatable(StubError.plainError)),
                        inputParams: stubSearchInputParams,
                        detailedEntity: nil
                    )
                }
            }

            context("else when the action is SearchAction.updateInputEditing") {

                context("and the editEvent is .beganEditing") {

                    let currentInputParams = SearchInputParams(params: stubSearchParams,
                                                               isEditing: false)
                    let currentState = SearchState(loadState: .idle,
                                                   inputParams: currentInputParams,
                                                   detailedEntity: nil)

                    beforeEach {
                        result = SearchReducer.reduce(action: SearchAction.updateInputEditing(.beganEditing),
                                                      currentState: currentState)
                    }

                    it("returns the expected state") {
                        expect(result) == SearchState(loadState: .idle,
                                                      inputParams: SearchInputParams(params: stubSearchParams,
                                                                                     isEditing: true),
                                                      detailedEntity: nil)
                    }

                }

                context("and the editEvent is .clearedInput") {

                    let currentInputParams = SearchInputParams(params: stubSearchParams,
                                                               isEditing: false)
                    let currentState = SearchState(loadState: .idle,
                                                   inputParams: currentInputParams,
                                                   detailedEntity: nil)

                    beforeEach {
                        result = SearchReducer.reduce(action: SearchAction.updateInputEditing(.clearedInput),
                                                      currentState: currentState)
                    }

                    it("returns the expected state") {
                        expect(result) == SearchState(loadState: .idle,
                                                      inputParams: SearchInputParams(params: nil,
                                                                                     isEditing: true),
                                                      detailedEntity: nil)
                    }

                }

                context("and the editEvent is .endedEditing") {

                    let currentParams = SearchParams.stubValue(keywords: NonEmptyString.stubValue())
                    let currentInputParams = SearchInputParams(params: currentParams,
                                                               isEditing: true)
                    let currentState = SearchState(loadState: .noResultsFound(stubSearchParams),
                                                   inputParams: currentInputParams,
                                                   detailedEntity: nil)

                    beforeEach {
                        result = SearchReducer.reduce(action: SearchAction.updateInputEditing(.endedEditing),
                                                      currentState: currentState)
                    }

                    it("returns the expected state") {
                        expect(result) == SearchState(loadState: .noResultsFound(stubSearchParams),
                                                      inputParams: SearchInputParams(params: stubSearchParams,
                                                                                     isEditing: false),
                                                      detailedEntity: nil)
                    }

                }

            }

            context("else when the action is SearchAction.detailedEntity") {
                let currentState = SearchState(loadState: .idle,
                                               inputParams: stubSearchInputParams,
                                               detailedEntity: nil)

                beforeEach {
                    result = SearchReducer.reduce(action: SearchAction.detailedEntity(stubDetailsViewModel),
                                                  currentState: currentState)
                }

                it("returns the expected state") {
                    expect(result) == SearchState(loadState: .idle,
                                                  inputParams: stubSearchInputParams,
                                                  detailedEntity: stubDetailsViewModel)
                }
            }

            context("else when the action is SearchAction.removeDetailedEntity") {
                let currentState = SearchState(loadState: .idle,
                                               inputParams: stubSearchInputParams,
                                               detailedEntity: stubDetailsViewModel)

                beforeEach {
                    result = SearchReducer.reduce(action: SearchAction.removeDetailedEntity,
                                                  currentState: currentState)
                }

                it("returns the expected state") {
                    expect(result) == SearchState(loadState: .idle,
                                                  inputParams: stubSearchInputParams,
                                                  detailedEntity: nil)
                }
            }

        }

    }

}
