//
//  SearchActionCreatorInitialPageTests.swift
//  PlacesFinderTests
//
//  Created by Justin Peckner.
//  Copyright © 2019 Justin Peckner. All rights reserved.
//

import CoreLocation
import Nimble
import Quick
import Shared
import SharedTestComponents
import SwiftDux
import SwiftDuxTestComponents

class SearchActionCreatorInitialPageTests: QuickSpec {

    // swiftlint:disable function_body_length
    // swiftlint:disable implicitly_unwrapped_optional
    override func spec() {

        let stubState = AppState.stubValue()
        let stubParams = PlaceLookupParams.stubValue(
            radius: stubState.searchPreferencesState.distance.distanceType.measurement,
            sorting: stubState.searchPreferencesState.sorting
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
            let action = SearchActionCreator.requestInitialPage(
                SearchActionCreatorDependencies(placeLookupService: mockPlaceLookupService,
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

            it("dispatches SearchAction.locationRequested") {
                performTest()

                let dispatchedAction = mockStore.dispatchedNonAsyncActions.first as? SearchAction
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

                it("dispatches SearchAction.failure") {
                    let dispatchedAction = mockStore.dispatchedNonAsyncActions.last as? SearchAction
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

                    it("dispatches SearchAction.failure") {
                        let dispatchedAction = mockStore.dispatchedNonAsyncActions.last as? SearchAction
                        expect(dispatchedAction) == .failure(
                            stubSearchParams,
                            underlyingError: IgnoredEquatable(SharedTestComponents.StubError.thrownError)
                        )
                    }
                }

                context("else") {

                    it("dispatches SearchAction.initialPageRequested") {
                        performTest()

                        let dispatchedAction = mockStore.dispatchedNonAsyncActions.last as? SearchAction
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

                            it("dispatches SearchAction.failure") {
                                let dispatchedAction = mockStore.dispatchedNonAsyncActions.last as? SearchAction
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

                            it("dispatches SearchAction.failure") {
                                let dispatchedAction = mockStore.dispatchedNonAsyncActions.last as? SearchAction
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

                            it("dispatches SearchAction.noResultsFound") {
                                let dispatchedAction = mockStore.dispatchedNonAsyncActions.last as? SearchAction
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

                                it("dispatches SearchAction.subsequentRequest with .success...") {
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

                                it("dispatches SearchAction.subsequentRequest with .success...") {
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
