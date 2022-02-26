//
//  SearchActivityActionCreatorInitialPageTests.swift
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
import SwiftDuxTestComponents

// swiftlint:disable:next type_name
class SearchActivityActionCreatorInitialPageTests: QuickSpec {

    // swiftlint:disable function_body_length
    // swiftlint:disable implicitly_unwrapped_optional
    override func spec() {

        let stubState = AppState.stubValue()
        let stubParams = PlaceLookupParams.stubValue(
            radius: stubState.searchPreferencesState.stored.distance.distanceType.measurement,
            sorting: stubState.searchPreferencesState.stored.sorting
        )
        let stubSearchParams = SearchParams(keywords: stubParams.keywords)

        var mockLocationRequestBlockCalled: Bool!
        var mockLocationRequestReturnValue: LocationRequestResult!
        var mockPlaceLookupService: PlaceLookupServiceProtocolMock!
        var mockSearchEntityModelBuilder: SearchEntityModelBuilderProtocolMock!
        var mockStore: MockAppStore!

        beforeEach {
            mockLocationRequestBlockCalled = false
            mockLocationRequestReturnValue = nil

            mockPlaceLookupService = PlaceLookupServiceProtocolMock()
            mockPlaceLookupService.buildInitialPageRequestTokenReturnValue = PlaceLookupPageRequestToken.stubValue()
            mockSearchEntityModelBuilder = SearchEntityModelBuilderProtocolMock()

            mockStore = MockAppStore()
            mockStore.stubState = stubState
        }

        func performTest() {
            let action = SearchActivityActionCreator.requestInitialPage(
                SearchActivityActionCreatorDependencies(placeLookupService: mockPlaceLookupService,
                                                        searchEntityModelBuilder: mockSearchEntityModelBuilder),
                searchParams: stubSearchParams
            ) { resultBlock in
                mockLocationRequestBlockCalled = true
                resultBlock(mockLocationRequestReturnValue)
            }

            mockStore.dispatch(action)
        }

        describe("requestInitialPage()") {

            let stubUnderlyingError = LocationRequestError.noLocationsReturned

            beforeEach {
                mockLocationRequestReturnValue = .failure(stubUnderlyingError)
            }

            it("dispatches SearchActivityAction.locationRequested") {
                performTest()

                let dispatchedAction = mockStore.dispatchedNonAsyncActions.first as? SearchActivityAction
                expect(dispatchedAction) == .locationRequested(stubSearchParams)
            }

            it("calls locationUpdateRequestBlock()") {
                performTest()

                expect(mockLocationRequestBlockCalled) == true
            }

            context("when locationUpdateRequestBlock() calls back with .failure") {
                beforeEach {
                    mockLocationRequestReturnValue = .failure(stubUnderlyingError)

                    performTest()
                }

                it("dispatches SearchActivityAction.failure") {
                    let dispatchedAction = mockStore.dispatchedNonAsyncActions.last as? SearchActivityAction
                    expect(dispatchedAction) == .failure(
                        stubSearchParams,
                        underlyingError: IgnoredEquatable(stubUnderlyingError)
                    )
                }
            }

            context("else when locationUpdateRequestBlock() calls back with .success") {

                beforeEach {
                    let coordinate = LocationCoordinate(latitude: stubParams.coordinate.latitude,
                                                        longitude: stubParams.coordinate.longitude)
                    mockLocationRequestReturnValue = .success(coordinate)
                }

                it("calls mockPlaceLookupService.buildInitialPageRequestToken()") {
                    performTest()

                    expect(mockPlaceLookupService.buildInitialPageRequestTokenReceivedPlaceLookupParams) == stubParams
                }

                context("when mockPlaceLookupService.buildInitialPageRequestToken() throws an error") {
                    beforeEach {
                        mockPlaceLookupService.buildInitialPageRequestTokenThrowableError =
                            SharedTestComponents.StubError.thrownError

                        performTest()
                    }

                    it("dispatches SearchActivityAction.failure") {
                        let dispatchedAction = mockStore.dispatchedNonAsyncActions.last as? SearchActivityAction
                        expect(dispatchedAction) == .failure(
                            stubSearchParams,
                            underlyingError: IgnoredEquatable(SharedTestComponents.StubError.thrownError)
                        )
                    }
                }

                context("else") {

                    it("dispatches SearchActivityAction.initialPageRequested") {
                        performTest()

                        let dispatchedAction = mockStore.dispatchedNonAsyncActions.last as? SearchActivityAction
                        expect(dispatchedAction) == .initialPageRequested(stubSearchParams)
                    }

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

                            it("dispatches SearchActivityAction.failure") {
                                let dispatchedAction = mockStore.dispatchedNonAsyncActions.last as? SearchActivityAction
                                expect(dispatchedAction) == .failure(
                                    stubSearchParams,
                                    underlyingError: IgnoredEquatable(stubUnderlyingError)
                                )
                            }
                        }

                        context("and the error is retriable") {
                            let errorPayload = PlaceLookupErrorPayload.codeAndDescription(
                                code: "SomeCode",
                                description: "SomeDescription"
                            )
                            let urlResponse = HTTPURLResponse.stubValue(statusCode: 500)
                            let stubUnderlyingError = PlaceLookupServiceError.errorPayloadReturned(
                                errorPayload,
                                urlResponse: urlResponse
                            )

                            beforeEach {
                                mockPlaceLookupService.requestPageCompletionClosure = { _, callback in
                                    callback(.failure(stubUnderlyingError))
                                }

                                performTest()
                            }

                            it("dispatches SearchActivityAction.failure") {
                                let dispatchedAction = mockStore.dispatchedNonAsyncActions.last as? SearchActivityAction
                                expect(dispatchedAction) == .failure(
                                    stubSearchParams,
                                    underlyingError: IgnoredEquatable(stubUnderlyingError)
                                )
                            }
                        }
                    }

                    context("when mockPlaceLookupService.requestPage() calls back with .success") {

                        context("and no search results were found") {
                            let stubResponse = PlaceLookupResponse.stubValue()

                            beforeEach {
                                mockPlaceLookupService.requestPageCompletionClosure = { _, callback in
                                    callback(.success(stubResponse))
                                }
                                mockSearchEntityModelBuilder.buildEntityModelsReturnValue = []

                                performTest()
                            }

                            it("dispatches SearchActivityAction.noResultsFound") {
                                let dispatchedAction = mockStore.dispatchedNonAsyncActions.last as? SearchActivityAction
                                expect(dispatchedAction) == .noResultsFound(stubSearchParams)
                            }
                        }

                        context("and search results were found") {

                            let stubEntityModels = [
                                SearchEntityModel.stubValue(name: "stubEntityA"),
                                SearchEntityModel.stubValue(name: "stubEntityB"),
                                SearchEntityModel.stubValue(name: "stubEntityC"),
                            ]

                            beforeEach {
                                mockSearchEntityModelBuilder.buildEntityModelsReturnValue = stubEntityModels
                            }

                            context("and a token for the next request is returned") {
                                let stubNextRequestToken = PlaceLookupPageRequestToken.stubValue()

                                beforeEach {
                                    mockPlaceLookupService.requestPageCompletionClosure = { _, callback in
                                        callback(.success(PlaceLookupResponse.stubValue(
                                            nextRequestTokenResult: .success(stubNextRequestToken)
                                        )))
                                    }
                                    mockSearchEntityModelBuilder.buildEntityModelsReturnValue = stubEntityModels

                                    performTest()
                                }

                                it("dispatches SearchActivityAction.subsequentRequest with .success...") {
                                    expect(mockStore.dispatchedPageAction) == .success
                                }

                                it("...and with the previous search params...") {
                                    expect(mockStore.dispatchedSubmittedParams) == stubSearchParams
                                }

                                it("...and with all entities received so far...") {
                                    expect(mockStore.dispatchedEntities?.value) == stubEntityModels
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

                                it("dispatches SearchActivityAction.subsequentRequest with .success...") {
                                    expect(mockStore.dispatchedPageAction) == .success
                                }

                                it("...and with the previous search params...") {
                                    expect(mockStore.dispatchedSubmittedParams) == stubSearchParams
                                }

                                it("...and with all entities received so far...") {
                                    expect(mockStore.dispatchedEntities?.value) == stubEntityModels
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

}