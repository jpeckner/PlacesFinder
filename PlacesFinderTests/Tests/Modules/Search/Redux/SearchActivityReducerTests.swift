//
//  SearchActivityReducerTests.swift
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

// swiftlint:disable blanket_disable_command
// swiftlint:disable function_body_length
// swiftlint:disable implicitly_unwrapped_optional
class SearchActivityReducerTests: QuickSpec {

    override func spec() {

        describe("reduce") {

            let stubParams = PlaceLookupParams.stubValue()
            let stubSearchParams = SearchParams(keywords: stubParams.keywords)
            let stubSearchInputParams = SearchInputParams(params: stubSearchParams,
                                                          barState: .isShowing(isEditing: false))

            let stubDetailsViewModel = SearchEntityModel.stubValue()
            let stubEntities = NonEmptyArray(with: SearchEntityModel.stubValue())
            let stubTokenContainer = PlaceLookupTokenAttemptsContainer.stubValue()

            let stubUpdateRequestParams = Search.ActivityAction.UpdateRequestStatusParams(
                searchParams: stubSearchParams,
                numPagesReceived: 1,
                allEntities: stubEntities,
                nextRequestToken: stubTokenContainer
            )

            var result: Search.ActivityState!

            context("else when the action is Search.ActivityAction.locationRequested") {
                let currentState = Search.ActivityState(
                    loadState: .idle,
                    inputParams: SearchInputParams(params: stubSearchParams,
                                                   barState: .isShowing(isEditing: true)),
                    detailedEntity: stubDetailsViewModel
                )

                beforeEach {
                    result = Search.ActivityReducer.reduce(
                        action: Search.ActivityAction.locationRequested(stubSearchParams),
                        currentState: currentState
                    )
                }

                it("returns the expected state") {
                    expect(result) == Search.ActivityState(
                        loadState: .locationRequested(stubSearchParams),
                        inputParams: stubSearchInputParams,
                        detailedEntity: nil
                    )
                }
            }

            context("else when the action is Search.ActivityAction.initialPageRequested") {
                let currentState = Search.ActivityState(
                    loadState: .idle,
                    inputParams: stubSearchInputParams,
                    detailedEntity: stubDetailsViewModel
                )

                beforeEach {
                    result = Search.ActivityReducer.reduce(
                        action: Search.ActivityAction.initialPageRequested(stubSearchParams),
                        currentState: currentState
                    )
                }

                it("returns the expected state") {
                    expect(result) == Search.ActivityState(
                        loadState: .initialPageRequested(stubSearchParams),
                        inputParams: stubSearchInputParams,
                        detailedEntity: nil
                    )
                }
            }

            context("else when the action is Search.ActivityAction.noResultsFound") {
                let currentState = Search.ActivityState(
                    loadState: .idle,
                    inputParams: stubSearchInputParams,
                    detailedEntity: stubDetailsViewModel
                )

                beforeEach {
                    result = Search.ActivityReducer.reduce(
                        action: Search.ActivityAction.noResultsFound(stubSearchParams),
                        currentState: currentState
                    )
                }

                it("returns the expected state") {
                    expect(result) == Search.ActivityState(
                        loadState: .noResultsFound(stubSearchParams),
                        inputParams: stubSearchInputParams,
                        detailedEntity: nil
                    )
                }
            }

            context("else when the action is Search.ActivityAction.updateRequestStatus") {

                func verifyResult(expectedPageState: SearchPageState,
                                  expectedEntities: NonEmptyArray<SearchEntityModel>,
                                  expectedToken: PlaceLookupTokenAttemptsContainer) {
                    expect(result.loadState) == .pagesReceived(params: stubSearchParams,
                                                               pageState: expectedPageState,
                                                               numPagesReceived: 1,
                                                               allEntities: expectedEntities,
                                                               nextRequestToken: expectedToken)

                    expect(result.detailedEntity) == stubDetailsViewModel
                }

                context("and the current loadState is not .pagesReceived") {
                    let currentState = Search.ActivityState(
                        loadState: .idle,
                        inputParams: stubSearchInputParams,
                        detailedEntity: stubDetailsViewModel
                    )

                    beforeEach {
                        let action = Search.ActivityAction.updateRequestStatus(
                            params: stubUpdateRequestParams,
                            pageAction: .success
                        )
                        result = Search.ActivityReducer.reduce(action: action,
                                                               currentState: currentState)
                    }

                    it("returns the expected state") {
                        verifyResult(expectedPageState: .inProgress,
                                     expectedEntities: stubEntities,
                                     expectedToken: stubTokenContainer)
                    }
                }

                context("else and the pageAction is .inProgress") {
                    let currentLoadState = Search.LoadState.pagesReceived(
                        params: stubSearchParams,
                        pageState: .success,
                        numPagesReceived: 1,
                        allEntities: stubEntities,
                        nextRequestToken: stubTokenContainer
                    )
                    let currentState = Search.ActivityState(
                        loadState: currentLoadState,
                        inputParams: stubSearchInputParams,
                        detailedEntity: stubDetailsViewModel
                    )

                    beforeEach {
                        let action = Search.ActivityAction.updateRequestStatus(
                            params: stubUpdateRequestParams,
                            pageAction: .inProgress
                        )
                        result = Search.ActivityReducer.reduce(action: action,
                                                               currentState: currentState)
                    }

                    it("returns the expected state") {
                        verifyResult(expectedPageState: .inProgress,
                                     expectedEntities: stubEntities,
                                     expectedToken: stubTokenContainer)
                    }
                }

                context("and the pageAction is .success") {
                    let currentLoadState = Search.LoadState.pagesReceived(
                        params: stubSearchParams,
                        pageState: .success,
                        numPagesReceived: 1,
                        allEntities: stubEntities,
                        nextRequestToken: stubTokenContainer
                    )
                    let currentState = Search.ActivityState(
                        loadState: currentLoadState,
                        inputParams: stubSearchInputParams,
                        detailedEntity: stubDetailsViewModel
                    )

                    beforeEach {
                        let action = Search.ActivityAction.updateRequestStatus(
                            params: stubUpdateRequestParams,
                            pageAction: .success
                        )
                        result = Search.ActivityReducer.reduce(action: action,
                                                               currentState: currentState)
                    }

                    it("returns the expected state") {
                        verifyResult(expectedPageState: .success,
                                     expectedEntities: stubEntities,
                                     expectedToken: stubTokenContainer)
                    }
                }

                context("and the pageAction is .failure") {
                    let currentLoadState = Search.LoadState.pagesReceived(
                        params: stubSearchParams,
                        pageState: .success,
                        numPagesReceived: 1,
                        allEntities: stubEntities,
                        nextRequestToken: stubTokenContainer
                    )
                    let currentState = Search.ActivityState(
                        loadState: currentLoadState,
                        inputParams: stubSearchInputParams,
                        detailedEntity: stubDetailsViewModel
                    )
                    let underlyingError = IgnoredEquatable<Error>(SharedTestComponents.StubError.plainError)
                    let pageError = Search.PageRequestError.cannotRetryRequest(underlyingError: underlyingError)

                    beforeEach {
                        let action = Search.ActivityAction.updateRequestStatus(
                            params: stubUpdateRequestParams,
                            pageAction: .failure(pageError)
                        )
                        result = Search.ActivityReducer.reduce(action: action,
                                                               currentState: currentState)
                    }

                    it("returns the expected state") {
                        verifyResult(expectedPageState: .failure(pageError),
                                     expectedEntities: stubEntities,
                                     expectedToken: stubTokenContainer)
                    }
                }
            }

            context("else when the action is Search.ActivityAction.failure") {
                let currentState = Search.ActivityState(
                    loadState: .idle,
                    inputParams: stubSearchInputParams,
                    detailedEntity: stubDetailsViewModel
                )

                beforeEach {
                    let action = Search.ActivityAction.failure(
                        stubSearchParams,
                        underlyingError: IgnoredEquatable(SharedTestComponents .StubError.plainError)
                    )
                    result = Search.ActivityReducer.reduce(action: action,
                                                           currentState: currentState)
                }

                it("returns the expected state") {
                    expect(result) == Search.ActivityState(
                        loadState: .failure(
                            stubSearchParams,
                            underlyingError: IgnoredEquatable(SharedTestComponents.StubError.plainError)
                        ),
                        inputParams: stubSearchInputParams,
                        detailedEntity: nil
                    )
                }
            }

            context("else when the action is Search.ActivityAction.updateInputEditing") {

                context("and the editEvent is .beganEditing") {

                    let currentInputParams = SearchInputParams(params: stubSearchParams,
                                                               barState: .isShowing(isEditing: false))
                    let currentState = Search.ActivityState(
                        loadState: .idle,
                        inputParams: currentInputParams,
                        detailedEntity: nil
                    )

                    beforeEach {
                        result = Search.ActivityReducer.reduce(
                            action: Search.ActivityAction.updateInputEditing(.beganEditing),
                            currentState: currentState
                        )
                    }

                    it("returns the expected state") {
                        expect(result) == Search.ActivityState(
                            loadState: .idle,
                            inputParams: SearchInputParams(params: stubSearchParams,
                                                           barState: .isShowing(isEditing: true)),
                            detailedEntity: nil
                        )
                    }

                }

                context("and the editEvent is .clearedInput") {

                    let currentInputParams = SearchInputParams(params: stubSearchParams,
                                                               barState: .isShowing(isEditing: false))
                    let currentState = Search.ActivityState(
                        loadState: .idle,
                        inputParams: currentInputParams,
                        detailedEntity: nil
                    )

                    beforeEach {
                        result = Search.ActivityReducer.reduce(
                            action: Search.ActivityAction.updateInputEditing(.clearedInput),
                            currentState: currentState
                        )
                    }

                    it("returns the expected state") {
                        expect(result) == Search.ActivityState(
                            loadState: .idle,
                            inputParams: SearchInputParams(params: nil,
                                                           barState: .isShowing(isEditing: true)),
                            detailedEntity: nil
                        )
                    }

                }

                context("and the editEvent is .endedEditing") {

                    let currentParams = SearchParams.stubValue(keywords: NonEmptyString.stubValue())
                    let currentInputParams = SearchInputParams(params: currentParams,
                                                               barState: .isShowing(isEditing: false))
                    let currentState = Search.ActivityState(
                        loadState: .noResultsFound(stubSearchParams),
                        inputParams: currentInputParams,
                        detailedEntity: nil
                    )

                    beforeEach {
                        result = Search.ActivityReducer.reduce(
                            action: Search.ActivityAction.updateInputEditing(.endedEditing),
                            currentState: currentState
                        )
                    }

                    it("returns the expected state") {
                        expect(result) == Search.ActivityState(
                            loadState: .noResultsFound(stubSearchParams),
                            inputParams: SearchInputParams(params: stubSearchParams,
                                                           barState: .isHidden),
                            detailedEntity: nil
                        )
                    }

                }

            }

            context("else when the action is Search.ActivityAction.detailedEntity") {
                let currentState = Search.ActivityState(
                    loadState: .idle,
                    inputParams: stubSearchInputParams,
                    detailedEntity: nil
                )

                beforeEach {
                    result = Search.ActivityReducer.reduce(
                        action: Search.ActivityAction.detailedEntity(stubDetailsViewModel),
                        currentState: currentState
                    )
                }

                it("returns the expected state") {
                    expect(result) == Search.ActivityState(
                        loadState: .idle,
                        inputParams: stubSearchInputParams,
                        detailedEntity: stubDetailsViewModel
                    )
                }
            }

            context("else when the action is Search.ActivityAction.removeDetailedEntity") {
                let currentState = Search.ActivityState(
                    loadState: .idle,
                    inputParams: stubSearchInputParams,
                    detailedEntity: stubDetailsViewModel
                )

                beforeEach {
                    result = Search.ActivityReducer.reduce(
                        action: Search.ActivityAction.removeDetailedEntity,
                        currentState: currentState
                    )
                }

                it("returns the expected state") {
                    expect(result) == Search.ActivityState(
                        loadState: .idle,
                        inputParams: stubSearchInputParams,
                        detailedEntity: nil
                    )
                }
            }

        }

    }

}
// swiftlint:enable blanket_disable_command
