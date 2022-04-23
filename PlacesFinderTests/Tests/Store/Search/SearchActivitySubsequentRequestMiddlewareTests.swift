//
//  SearchActivitySubsequentRequestMiddlewareTests.swift
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
import SwiftDux
import SwiftDuxTestComponents

// swiftlint:disable:next type_name
class SearchActivitySubsequentRequestMiddlewareTests: QuickSpec {

    // swiftlint:disable function_body_length
    // swiftlint:disable implicitly_unwrapped_optional
    // swiftlint:disable line_length
    override func spec() {

        let stubState = AppState.stubValue()
        let stubParams = PlaceLookupParams.stubValue()
        let stubSearchParams = SearchParams(keywords: stubParams.keywords)
        let stubPreviousResults = NonEmptyArray(with: SearchEntityModel.stubValue(name: "previousResult"))
        let stubTokenContainer = PlaceLookupTokenAttemptsContainer.stubValue()

        var mockPlaceLookupService: PlaceLookupServiceProtocolMock!
        var mockSearchEntityModelBuilder: SearchEntityModelBuilderProtocolMock!
        var mockStore: SpyingStore<AppAction, AppState>!

        beforeEach {
            mockPlaceLookupService = PlaceLookupServiceProtocolMock()
            mockSearchEntityModelBuilder = SearchEntityModelBuilderProtocolMock()
            mockStore = SpyingStore(
                reducer: AppStateReducer.reduce,
                initialState: stubState,
                middleware: [
                    Search.ActivityMiddleware.buildSubsequentRequestMiddleware()
                ]
            )
        }

        func performTest() {
            let dependencies = Search.ActivityActionCreatorDependencies(
                placeLookupService: mockPlaceLookupService,
                searchEntityModelBuilder: mockSearchEntityModelBuilder
            )
            let action = SearchActivityAction.startSubsequentRequest(dependencies: dependencies,
                                                                     searchParams: stubSearchParams,
                                                                     previousResults: stubPreviousResults,
                                                                     tokenContainer: stubTokenContainer)

            mockStore.dispatch(action)
        }

        describe("requestSubsequentPage(:previousResults)") {

            describe("dispatch .inProgress") {
                beforeEach {
                    performTest()
                }

                it("dispatches SearchActivityAction.subsequentRequest with .inProgress") {
                    expect(mockStore.dispatchedPageAction) == .inProgress
                }

                it("...and with the previously received search params...") {
                    expect(mockStore.dispatchedSubmittedParams) == stubSearchParams
                }

                it("...and with the previously received entities...") {
                    expect(mockStore.dispatchedEntities) == stubPreviousResults
                }

                it("...and a nil value for the next request token") {
                    expect(mockStore.dispatchedNextRequestToken).to(beNil())
                }
            }

            describe("requestPage") {

                it("calls mockPlaceLookupService.requestPage()") {
                    performTest()

                    expect(mockPlaceLookupService.requestPageCompletionCalled) == true
                }

                context("when mockPlaceLookupService.requestPage() calls back with .failure") {

                    context("and the error is not retriable") {
                        let stubUnderlyingError = PlaceLookupServiceError.unexpectedDecodingError(underlyingError:
                            .noDataReturned(HTTPURLResponse.stubValue())
                        )

                        beforeEach {
                            mockPlaceLookupService.requestPageCompletionClosure = { _, callback in
                                callback(.failure(stubUnderlyingError))
                            }
                            performTest()
                        }

                        it("dispatches .subsequentRequest(.failure), with an error of .cannotRetryRequest") {
                            expect(mockStore.dispatchedPageAction) == .failure(
                                .cannotRetryRequest(underlyingError: IgnoredEquatable(stubUnderlyingError))
                            )
                        }

                        it("...and with the previously received search params...") {
                            expect(mockStore.dispatchedSubmittedParams) == stubSearchParams
                        }

                        it("...and with the previously received entities...") {
                            expect(mockStore.dispatchedEntities) == stubPreviousResults
                        }

                        it("...and a nil value for the next request token") {
                            expect(mockStore.dispatchedNextRequestToken).to(beNil())
                        }
                    }

                    context("and the error is retriable") {
                        let errorPayload = PlaceLookupErrorPayload.codeAndDescription(code: "SomeCode",
                                                                                      description: "SomeDescription")
                        let urlResponse = HTTPURLResponse.stubValue(statusCode: 500)
                        let stubUnderlyingError = PlaceLookupServiceError.errorPayloadReturned(errorPayload,
                                                                                               urlResponse: urlResponse)

                        beforeEach {
                            mockPlaceLookupService.requestPageCompletionClosure = { _, callback in
                                callback(.failure(stubUnderlyingError))
                            }

                            performTest()
                        }

                        it("dispatches .subsequentRequest(.failure), with an error of .canRetryRequest") {
                            expect(mockStore.dispatchedPageAction) == .failure(.canRetryRequest(
                                underlyingError: IgnoredEquatable(stubUnderlyingError)
                            ))
                        }

                        it("...and with the previously received search params...") {
                            expect(mockStore.dispatchedSubmittedParams) == stubSearchParams
                        }

                        it("...and with the previously received entities...") {
                            expect(mockStore.dispatchedEntities) == stubPreviousResults
                        }

                        it("...and the same request token used for the failing request") {
                            expect(mockStore.dispatchedNextRequestToken) == stubTokenContainer
                        }
                    }

                }

                context("when mockPlaceLookupService.requestPage() calls back with .success") {

                    context("and no search results were found") {
                        beforeEach {
                            mockPlaceLookupService.requestPageCompletionClosure = { _, callback in
                                callback(.success(PlaceLookupResponse.stubValue()))
                            }
                            mockSearchEntityModelBuilder.buildEntityModelsReturnValue = []

                            performTest()
                        }

                        it("dispatches SearchActivityAction.subsequentRequest with .success") {
                            expect(mockStore.dispatchedPageAction) == .success
                        }

                        it("...and with the previously received search params...") {
                            expect(mockStore.dispatchedSubmittedParams) == stubSearchParams
                        }

                        it("...and with the previously received entities...") {
                            expect(mockStore.dispatchedEntities) == stubPreviousResults
                        }

                        it("...and a nil value for the next request token") {
                            expect(mockStore.dispatchedNextRequestToken).to(beNil())
                        }
                    }

                    context("and search results were found") {

                        let stubReceivedEntityModels = [
                            SearchEntityModel.stubValue(name: "stubEntityA"),
                            SearchEntityModel.stubValue(name: "stubEntityB"),
                            SearchEntityModel.stubValue(name: "stubEntityC"),
                        ]

                        beforeEach {
                            mockSearchEntityModelBuilder.buildEntityModelsReturnValue = stubReceivedEntityModels
                        }

                        context("and a token for the next request is returned") {
                            let stubNextRequestToken = PlaceLookupPageRequestToken.stubValue()

                            beforeEach {
                                mockPlaceLookupService.requestPageCompletionClosure = { _, callback in
                                    callback(.success(PlaceLookupResponse.stubValue(
                                        nextRequestTokenResult: .success(stubNextRequestToken)
                                    )))
                                }

                                performTest()
                            }

                            it("dispatches SearchActivityAction.subsequentRequest with .success") {
                                expect(mockStore.dispatchedPageAction) == .success
                            }

                            it("...and with the previously received search params...") {
                                expect(mockStore.dispatchedSubmittedParams) == stubSearchParams
                            }

                            it("...and with all entities received so far...") {
                                expect(mockStore.dispatchedEntities) == stubPreviousResults.appendedWith(stubReceivedEntityModels)
                            }

                            it("...and the returned next request token, with numAttemptsSoFar == 0") {
                                expect(mockStore.dispatchedNextRequestToken) == PlaceLookupTokenAttemptsContainer(
                                    token: stubNextRequestToken,
                                    maxAttempts: 3,
                                    numAttemptsSoFar: 0
                                )
                            }
                        }

                        context("and a token for the next request is not returned") {

                            beforeEach {
                                mockPlaceLookupService.requestPageCompletionClosure = { _, callback in
                                    callback(.success(PlaceLookupResponse.stubValue(nextRequestTokenResult: nil)))
                                }
                                performTest()
                            }

                            it("dispatches SearchActivityAction.subsequentRequest .success") {
                                expect(mockStore.dispatchedPageAction) == .success
                            }

                            it("...and with the previously received search params...") {
                                expect(mockStore.dispatchedSubmittedParams) == stubSearchParams
                            }

                            it("...and with all entities received so far...") {
                                expect(mockStore.dispatchedEntities) == stubPreviousResults.appendedWith(stubReceivedEntityModels)
                            }

                            it("...and a nil value for the next request token") {
                                expect(mockStore.dispatchedNextRequestToken).to(beNil())
                            }
                        }

                    }

                }

            }

        }

    }

}
