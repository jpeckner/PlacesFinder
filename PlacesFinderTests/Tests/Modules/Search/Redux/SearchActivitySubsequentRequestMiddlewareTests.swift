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

// swiftlint:disable blanket_disable_command
// swiftlint:disable function_body_length
// swiftlint:disable implicitly_unwrapped_optional
// swiftlint:disable line_length
// swiftlint:disable:next type_name
class SearchActivitySubsequentRequestMiddlewareTests: QuickSpec {

    override func spec() {

        let stubState = Search.State.stub()
        let stubParams = PlaceLookupParams.stubValue()
        let stubSearchParams = SearchParams(keywords: stubParams.keywords)
        let stubPreviousResults = NonEmptyArray(with: SearchEntityModel.stubValue(name: "previousResult"))
        let stubTokenContainer = PlaceLookupTokenAttemptsContainer.stubValue()

        var mockPlaceLookupService: PlaceLookupServiceProtocolMock!
        var mockSearchEntityModelBuilder: SearchEntityModelBuilderProtocolMock!
        var mockDependencies: Search.ActivityActionCreatorDependencies!
        var mockStore: SpyingStore<Search.Action, Search.State>!

        beforeEach {
            mockPlaceLookupService = PlaceLookupServiceProtocolMock()
            mockSearchEntityModelBuilder = SearchEntityModelBuilderProtocolMock()
            mockDependencies = Search.ActivityActionCreatorDependencies(
                placeLookupService: mockPlaceLookupService,
                searchEntityModelBuilder: mockSearchEntityModelBuilder
            )
            mockStore = SpyingStore(
                reducer: Search.reduce,
                initialState: stubState,
                middleware: [
                    Search.makeSubsequentRequestMiddleware()
                ]
            )
        }

        func performTest() {
            let action = Search.ActivityAction.startSubsequentRequest(
                dependencies: IgnoredEquatable(mockDependencies),
                params: .stubValue(
                    searchParams: stubSearchParams,
                    previousResults: stubPreviousResults,
                    tokenContainer: stubTokenContainer
                )
            )

            mockStore.dispatch(.searchActivity(action))
        }

        describe("requestSubsequentPage(:previousResults)") {

            describe("dispatch .inProgress") {
                beforeEach {
                    mockPlaceLookupService.requestPageRequestTokenReturnValue = .success(PlaceLookupResponse.stubValue())
                    mockSearchEntityModelBuilder.buildEntityModelsReturnValue = []

                    performTest()
                }

                it("dispatches Search.ActivityAction.updateRequestStatus with .inProgress") {
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
                    mockPlaceLookupService.requestPageRequestTokenReturnValue = .success(PlaceLookupResponse.stubValue())
                    mockSearchEntityModelBuilder.buildEntityModelsReturnValue = []
                    performTest()

                    await expect(mockPlaceLookupService.requestPageRequestTokenCalled).toEventually(beTrue())
                }

                context("when mockPlaceLookupService.requestPage() calls back with .failure") {

                    context("and the error is not retriable") {
                        let stubUnderlyingError = PlaceLookupServiceError.unexpectedDecodingError(underlyingError:
                            .noDataReturned(HTTPURLResponse.stubValue())
                        )

                        beforeEach {
                            mockPlaceLookupService.requestPageRequestTokenReturnValue = .failure(stubUnderlyingError)

                            performTest()
                        }

                        it("dispatches .updateRequestStatus(.failure), with an error of .cannotRetryRequest") {
                            await expect(mockStore.dispatchedPageAction).toEventually(equal(.failure(
                                .cannotRetryRequest(underlyingError: IgnoredEquatable(stubUnderlyingError))
                            )))
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
                            mockPlaceLookupService.requestPageRequestTokenReturnValue = .failure(stubUnderlyingError)

                            performTest()
                        }

                        it("dispatches .updateRequestStatus(.failure), with an error of .canRetryRequest") {
                            await expect(mockStore.dispatchedPageAction).toEventually(equal(.failure(.canRetryRequest(
                                underlyingError: IgnoredEquatable(stubUnderlyingError)
                            ))))
                        }

                        it("...and with the previously received search params...") {
                            expect(mockStore.dispatchedSubmittedParams) == stubSearchParams
                        }

                        it("...and with the previously received entities...") {
                            expect(mockStore.dispatchedEntities) == stubPreviousResults
                        }

                        it("...and the same request token used for the failing request") {
                            await expect(mockStore.dispatchedNextRequestToken).toEventually(equal(stubTokenContainer))
                        }
                    }

                }

                context("when mockPlaceLookupService.requestPage() calls back with .success") {

                    context("and no search results were found") {
                        beforeEach {
                            mockPlaceLookupService.requestPageRequestTokenReturnValue = .success(PlaceLookupResponse.stubValue())
                            mockSearchEntityModelBuilder.buildEntityModelsReturnValue = []

                            performTest()
                        }

                        it("dispatches Search.ActivityAction.updateRequestStatus with .success") {
                            await expect(mockStore.dispatchedPageAction).toEventually(equal(.success))
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
                                mockPlaceLookupService.requestPageRequestTokenReturnValue =
                                    .success(PlaceLookupResponse.stubValue(
                                        nextRequestTokenResult: .success(stubNextRequestToken)
                                    ))

                                performTest()
                            }

                            it("dispatches Search.ActivityAction.updateRequestStatus with .success") {
                                await expect(mockStore.dispatchedPageAction).toEventually(equal(.success))
                            }

                            it("...and with the previously received search params...") {
                                expect(mockStore.dispatchedSubmittedParams) == stubSearchParams
                            }

                            it("...and with all entities received so far...") {
                                await expect(mockStore.dispatchedEntities).toEventually(equal(stubPreviousResults.appendedWith(stubReceivedEntityModels)))
                            }

                            it("...and the returned next request token, with numAttemptsSoFar == 0") {
                                await expect(mockStore.dispatchedNextRequestToken).toEventually(equal(PlaceLookupTokenAttemptsContainer(
                                    token: stubNextRequestToken,
                                    maxAttempts: 3,
                                    numAttemptsSoFar: 0
                                )))
                            }
                        }

                        context("and a token for the next request is not returned") {

                            beforeEach {
                                mockPlaceLookupService.requestPageRequestTokenReturnValue =
                                    .success(PlaceLookupResponse.stubValue(nextRequestTokenResult: nil))

                                performTest()
                            }

                            it("dispatches Search.ActivityAction.updateRequestStatus .success") {
                                await expect(mockStore.dispatchedPageAction).toEventually(equal(.success))
                            }

                            it("...and with the previously received search params...") {
                                expect(mockStore.dispatchedSubmittedParams) == stubSearchParams
                            }

                            it("...and with all entities received so far...") {
                                await expect(mockStore.dispatchedEntities).toEventually(equal(stubPreviousResults.appendedWith(stubReceivedEntityModels)))
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
// swiftlint:enable blanket_disable_command
