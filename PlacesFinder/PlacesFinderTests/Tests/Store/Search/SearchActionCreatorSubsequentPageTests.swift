//
//  SearchActionCreatorSubsequentPageTests.swift
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
import SwiftDux
import SwiftDuxTestComponents

class SearchActionCreatorSubsequentPageTests: QuickSpec {

    // swiftlint:disable function_body_length
    // swiftlint:disable implicitly_unwrapped_optional
    // swiftlint:disable line_length
    override func spec() {

        let stubParams = PlaceLookupParams.stubValue()
        let stubSubmittedParams = SearchSubmittedParams(keywords: stubParams.keywords)
        let stubDetailsViewModel = SearchEntityModel.stubValue()
        let stubPreviousResults = NonEmptyArray(with: SearchEntityModel.stubValue(name: "previousResult"))
        let stubTokenContainer = PlaceLookupTokenAttemptsContainer.stubValue()

        var mockPlaceLookupService: PlaceLookupServiceProtocolMock!
        var mockSearchEntityModelBuilder: SearchEntityModelBuilderProtocolMock!
        var mockStore: MockAppStore!

        beforeEach {
            mockPlaceLookupService = PlaceLookupServiceProtocolMock()
            mockSearchEntityModelBuilder = SearchEntityModelBuilderProtocolMock()
            mockStore = MockAppStore()
        }

        func performTest() {
            let action = SearchActionCreator.requestSubsequentPage(
                SearchActionCreatorDependencies(placeLookupService: mockPlaceLookupService,
                                                searchEntityModelBuilder: mockSearchEntityModelBuilder),
                submittedParams: stubSubmittedParams,
                previousResults: stubPreviousResults,
                tokenContainer: stubTokenContainer
            )

            mockStore.dispatch(action)
        }

        describe("requestSubsequentPage(:previousResults)") {

            describe("dispatch .inProgress") {
                beforeEach {
                    performTest()
                }

                it("dispatches SearchAction.subsequentRequest with .inProgress") {
                    expect(mockStore.dispatchedPageAction) == .inProgress
                }

                it("...and with the previously received search params...") {
                    expect(mockStore.dispatchedSubmittedParams) == stubSubmittedParams
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
                            expect(mockStore.dispatchedSubmittedParams) == stubSubmittedParams
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
                            expect(mockStore.dispatchedSubmittedParams) == stubSubmittedParams
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

                        it("dispatches SearchAction.subsequentRequest with .success") {
                            expect(mockStore.dispatchedPageAction) == .success
                        }

                        it("...and with the previously received search params...") {
                            expect(mockStore.dispatchedSubmittedParams) == stubSubmittedParams
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

                            it("dispatches SearchAction.subsequentRequest with .success") {
                                expect(mockStore.dispatchedPageAction) == .success
                            }

                            it("...and with the previously received search params...") {
                                expect(mockStore.dispatchedSubmittedParams) == stubSubmittedParams
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

                            it("dispatches SearchAction.subsequentRequest .success") {
                                expect(mockStore.dispatchedPageAction) == .success
                            }

                            it("...and with the previously received search params...") {
                                expect(mockStore.dispatchedSubmittedParams) == stubSubmittedParams
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
