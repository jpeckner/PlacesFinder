//
//  SearchReducerTests.swift
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

            context("when the action is not a SearchActivityAction") {
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

            context("else when the action is SearchActivityAction.locationRequested") {
                let currentState = SearchState(loadState: .idle,
                                               inputParams: SearchInputParams(params: stubSearchParams,
                                                                              isEditing: true),
                                               detailedEntity: stubDetailsViewModel)

                beforeEach {
                    result = SearchReducer.reduce(action: SearchActivityAction.locationRequested(stubSearchParams),
                                                  currentState: currentState)
                }

                it("returns the expected state") {
                    expect(result) == SearchState(loadState: .locationRequested(stubSearchParams),
                                                  inputParams: stubSearchInputParams,
                                                  detailedEntity: nil)
                }
            }

            context("else when the action is SearchActivityAction.initialPageRequested") {
                let currentState = SearchState(loadState: .idle,
                                               inputParams: stubSearchInputParams,
                                               detailedEntity: stubDetailsViewModel)

                beforeEach {
                    result = SearchReducer.reduce(action: SearchActivityAction.initialPageRequested(stubSearchParams),
                                                  currentState: currentState)
                }

                it("returns the expected state") {
                    expect(result) == SearchState(loadState: .initialPageRequested(stubSearchParams),
                                                  inputParams: stubSearchInputParams,
                                                  detailedEntity: nil)
                }
            }

            context("else when the action is SearchActivityAction.noResultsFound") {
                let currentState = SearchState(loadState: .idle,
                                               inputParams: stubSearchInputParams,
                                               detailedEntity: stubDetailsViewModel)

                beforeEach {
                    result = SearchReducer.reduce(action: SearchActivityAction.noResultsFound(stubSearchParams),
                                                  currentState: currentState)
                }

                it("returns the expected state") {
                    expect(result) == SearchState(loadState: .noResultsFound(stubSearchParams),
                                                  inputParams: stubSearchInputParams,
                                                  detailedEntity: nil)
                }
            }

            context("else when the action is SearchActivityAction.subsequentRequest") {

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
                        let action = SearchActivityAction.subsequentRequest(
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
                        let action = SearchActivityAction.subsequentRequest(
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
                        let action = SearchActivityAction.subsequentRequest(
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
                    let underlyingError = IgnoredEquatable<Error>(SharedTestComponents.StubError.plainError)
                    let pageError = SearchPageRequestError.cannotRetryRequest(underlyingError: underlyingError)

                    beforeEach {
                        let action = SearchActivityAction.subsequentRequest(
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

            context("else when the action is SearchActivityAction.failure") {
                let currentState = SearchState(loadState: .idle,
                                               inputParams: stubSearchInputParams,
                                               detailedEntity: stubDetailsViewModel)

                beforeEach {
                    let action = SearchActivityAction.failure(
                        stubSearchParams,
                        underlyingError: IgnoredEquatable(SharedTestComponents .StubError.plainError)
                    )
                    result = SearchReducer.reduce(action: action,
                                                  currentState: currentState)
                }

                it("returns the expected state") {
                    expect(result) == SearchState(
                        loadState: .failure(
                            stubSearchParams,
                            underlyingError: IgnoredEquatable(SharedTestComponents.StubError.plainError)
                        ),
                        inputParams: stubSearchInputParams,
                        detailedEntity: nil
                    )
                }
            }

            context("else when the action is SearchActivityAction.updateInputEditing") {

                context("and the editEvent is .beganEditing") {

                    let currentInputParams = SearchInputParams(params: stubSearchParams,
                                                               isEditing: false)
                    let currentState = SearchState(loadState: .idle,
                                                   inputParams: currentInputParams,
                                                   detailedEntity: nil)

                    beforeEach {
                        result = SearchReducer.reduce(action: SearchActivityAction.updateInputEditing(.beganEditing),
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
                        result = SearchReducer.reduce(action: SearchActivityAction.updateInputEditing(.clearedInput),
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
                        result = SearchReducer.reduce(action: SearchActivityAction.updateInputEditing(.endedEditing),
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

            context("else when the action is SearchActivityAction.detailedEntity") {
                let currentState = SearchState(loadState: .idle,
                                               inputParams: stubSearchInputParams,
                                               detailedEntity: nil)

                beforeEach {
                    result = SearchReducer.reduce(action: SearchActivityAction.detailedEntity(stubDetailsViewModel),
                                                  currentState: currentState)
                }

                it("returns the expected state") {
                    expect(result) == SearchState(loadState: .idle,
                                                  inputParams: stubSearchInputParams,
                                                  detailedEntity: stubDetailsViewModel)
                }
            }

            context("else when the action is SearchActivityAction.removeDetailedEntity") {
                let currentState = SearchState(loadState: .idle,
                                               inputParams: stubSearchInputParams,
                                               detailedEntity: stubDetailsViewModel)

                beforeEach {
                    result = SearchReducer.reduce(action: SearchActivityAction.removeDetailedEntity,
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
