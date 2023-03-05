//
//  Search+ActivityAction.swift
//  PlacesFinder
//
//  Copyright (c) 2018 Justin Peckner
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

import Foundation
import Shared
import SwiftDux

extension Search {

    enum PageRequestError: Error, Equatable {
        case cannotRetryRequest(underlyingError: IgnoredEquatable<Error>)
        case canRetryRequest(underlyingError: IgnoredEquatable<Error>)
    }

    enum ActivityAction: Equatable {
        struct StartSubsequentRequestParams: Equatable {
            let searchParams: SearchParams
            let numPagesReceived: Int
            let previousResults: NonEmptyArray<SearchEntityModel>
            let tokenContainer: PlaceLookupTokenAttemptsContainer
        }

        struct UpdateRequestStatusParams: Equatable {
            let searchParams: SearchParams
            let pageAction: IntermediateStepLoadAction<Search.PageRequestError>
            let numPagesReceived: Int
            let allEntities: NonEmptyArray<SearchEntityModel>
            let nextRequestToken: PlaceLookupTokenAttemptsContainer?
        }

        case startInitialRequest(
            dependencies: IgnoredEquatable<ActivityActionCreatorDependencies>,
            searchParams: SearchParams,
            locationUpdateRequestBlock: IgnoredEquatable<LocationUpdateRequestBlock>
        )

        case startSubsequentRequest(
            dependencies: IgnoredEquatable<ActivityActionCreatorDependencies>,
            params: StartSubsequentRequestParams
        )

        // Load state
        case locationRequested(SearchParams)

        case initialPageRequested(SearchParams)

        case noResultsFound(SearchParams)

        case updateRequestStatus(UpdateRequestStatusParams)

        case failure(
            SearchParams,
            underlyingError: IgnoredEquatable<Error>
        )

        // Input params
        case updateInputEditing(SearchBarEditEvent)

        // Detailed entity
        case detailedEntity(SearchEntityModel)

        case removeDetailedEntity
    }

}

extension Search {

    struct ActivityActionCreatorDependencies {
        let placeLookupService: PlaceLookupServiceProtocol
        let searchEntityModelBuilder: SearchEntityModelBuilderProtocol
    }

}

extension Search {

    static func makeInitialRequestMiddleware<TAppStore: DispatchingStoreProtocol>(
        appStore: TAppStore
    ) -> Middleware<Search.Action, Search.State> where TAppStore.TAction == AppAction {
        return { dispatch, _ in
            return { next in
                return { action in
                    guard case let .searchActivity(.startInitialRequest(
                        dependencies,
                        searchParams,
                        locationUpdateRequestBlock
                    )) = action
                    else {
                        next(action)
                        return
                    }

                    dispatch(.searchActivity(.locationRequested(searchParams)))

                    appStore.dispatch(.receiveState(IgnoredEquatable { appState in
                        Task {
                            await requestLocation(
                                appState.searchPreferencesState,
                                dependencies: dependencies.value,
                                searchParams: searchParams,
                                locationUpdateRequestBlock: locationUpdateRequestBlock.value,
                                dispatch: dispatch
                            )
                        }
                    }))
                }
            }
        }
    }

    private static func requestLocation(_ preferencesState: SearchPreferencesState,
                                        dependencies: Search.ActivityActionCreatorDependencies,
                                        searchParams: SearchParams,
                                        locationUpdateRequestBlock: LocationUpdateRequestBlock,
                                        dispatch: @escaping DispatchFunction<Search.Action>) async {
        let result = await locationUpdateRequestBlock()

        switch result {
        case let .success(coordinate):
            let lookupParams = PlaceLookupParams(
                keywords: searchParams.keywords,
                coordinate: coordinate,
                radius: preferencesState.stored.distance.distanceType.measurement,
                sorting: preferencesState.stored.sorting
            )

            performInitialPageRequest(lookupParams,
                                      dependencies: dependencies,
                                      searchParams: searchParams,
                                      dispatch: dispatch)
        case let .failure(error):
            dispatchInitialPageFailure(searchParams,
                                       underlyingError: error,
                                       dispatch: dispatch)
        }
    }

    private static func performInitialPageRequest(_ placeLookupParams: PlaceLookupParams,
                                                  dependencies: Search.ActivityActionCreatorDependencies,
                                                  searchParams: SearchParams,
                                                  dispatch: @escaping DispatchFunction<Search.Action>) {
        do {
            let placeLookupService = dependencies.placeLookupService
            let initialRequestToken = try placeLookupService.buildInitialPageRequestToken(
                placeLookupParams: placeLookupParams
            )

            dispatch(.searchActivity(.initialPageRequested(searchParams)))

            Task {
                let result = await placeLookupService.requestPage(requestToken: initialRequestToken)

                switch result {
                case let .success(lookupResponse):
                    dispatchInitialPageSuccess(dependencies,
                                               searchParams: searchParams,
                                               lookupResponse: lookupResponse,
                                               dispatch: dispatch)
                case let .failure(error):
                    dispatchInitialPageFailure(searchParams,
                                               underlyingError: error,
                                               dispatch: dispatch)
                }
            }
        } catch {
            dispatchInitialPageFailure(searchParams,
                                       underlyingError: error,
                                       dispatch: dispatch)
        }
    }

    private static func dispatchInitialPageSuccess(_ dependencies: Search.ActivityActionCreatorDependencies,
                                                   searchParams: SearchParams,
                                                   lookupResponse: PlaceLookupResponse,
                                                   dispatch: @escaping DispatchFunction<Search.Action>) {
        let entityModels = dependencies.searchEntityModelBuilder.buildEntityModels(lookupResponse.page.entities)
        guard let allEntities = NonEmptyArray(entityModels) else {
            dispatch(.searchActivity(.noResultsFound(searchParams)))
            return
        }

        let params = Search.ActivityAction.UpdateRequestStatusParams(
            searchParams: searchParams,
            pageAction: .success,
            numPagesReceived: 1,
            allEntities: allEntities,
            nextRequestToken: tokenContainer(for: lookupResponse)
        )
        dispatch(.searchActivity(.updateRequestStatus(params)))
    }

    private static func dispatchInitialPageFailure(_ searchParams: SearchParams,
                                                   underlyingError: Error,
                                                   dispatch: @escaping DispatchFunction<Search.Action>) {
        dispatch(.searchActivity(.failure(searchParams,
                                          underlyingError: IgnoredEquatable(underlyingError))))
    }

}

extension Search {

    static func makeSubsequentRequestMiddleware() -> Middleware<Search.Action, Search.State> {
        return { dispatch, _ in
            return { next in
                return { action in
                    guard case let .searchActivity(.startSubsequentRequest(
                        dependencies,
                        startSubsequentRequestParams
                    )) = action
                    else {
                        next(action)
                        return
                    }

                    let inProgressStatusParams = Search.ActivityAction.UpdateRequestStatusParams(
                        searchParams: startSubsequentRequestParams.searchParams,
                        pageAction: .inProgress,
                        numPagesReceived: startSubsequentRequestParams.numPagesReceived,
                        allEntities: startSubsequentRequestParams.previousResults,
                        nextRequestToken: nil
                    )
                    dispatch(.searchActivity(.updateRequestStatus(inProgressStatusParams)))

                    Task {
                        let result = await dependencies.value.placeLookupService.requestPage(
                            requestToken: startSubsequentRequestParams.tokenContainer.token
                        )

                        switch result {
                        case let .success(lookupResponse):
                            dispatchSubsequentPageSuccess(lookupResponse: lookupResponse,
                                                          dependencies: dependencies.value,
                                                          startSubsequentRequestParams: startSubsequentRequestParams,
                                                          dispatch: dispatch)
                        case let .failure(error):
                            dispatchSubsequentPageError(placeLookupServiceError: error,
                                                        startSubsequentRequestParams: startSubsequentRequestParams,
                                                        dispatch: dispatch)
                        }
                    }
                }
            }
        }
    }

    private static func dispatchSubsequentPageSuccess(
        lookupResponse: PlaceLookupResponse,
        dependencies: Search.ActivityActionCreatorDependencies,
        startSubsequentRequestParams: Search.ActivityAction.StartSubsequentRequestParams,
        dispatch: @escaping DispatchFunction<Search.Action>
    ) {
        let entityModels = dependencies.searchEntityModelBuilder.buildEntityModels(lookupResponse.page.entities)
        let updateRequestStatusParams = Search.ActivityAction.UpdateRequestStatusParams(
            searchParams: startSubsequentRequestParams.searchParams,
            pageAction: .success,
            numPagesReceived: startSubsequentRequestParams.numPagesReceived + 1,
            allEntities: startSubsequentRequestParams.previousResults.appendedWith(entityModels),
            nextRequestToken: tokenContainer(for: lookupResponse)
        )

        dispatch(.searchActivity(.updateRequestStatus(updateRequestStatusParams)))
    }

    private static func dispatchSubsequentPageError(
        placeLookupServiceError: PlaceLookupServiceError,
        startSubsequentRequestParams: Search.ActivityAction.StartSubsequentRequestParams,
        dispatch: @escaping DispatchFunction<Search.Action>
    ) {
        let underlyingError = IgnoredEquatable<Error>(placeLookupServiceError)
        let isRequestRetriable = placeLookupServiceError.isRetriable
        let pageError: Search.PageRequestError = isRequestRetriable ?
            .canRetryRequest(underlyingError: underlyingError)
            :
            .cannotRetryRequest(underlyingError: underlyingError)
        let nextRequestToken = isRequestRetriable ? startSubsequentRequestParams.tokenContainer : nil
        let updateRequestStatusParams = Search.ActivityAction.UpdateRequestStatusParams(
            searchParams: startSubsequentRequestParams.searchParams,
            pageAction: .failure(pageError),
            numPagesReceived: startSubsequentRequestParams.numPagesReceived,
            allEntities: startSubsequentRequestParams.previousResults,
            nextRequestToken: nextRequestToken
        )

        dispatch(.searchActivity(.updateRequestStatus(updateRequestStatusParams)))
    }

}

private extension Search {

    static func tokenContainer(for lookupResponse: PlaceLookupResponse) -> PlaceLookupTokenAttemptsContainer? {
        let nextRequestToken = try? lookupResponse.nextRequestTokenResult?.get()
        return nextRequestToken.map {
            PlaceLookupTokenAttemptsContainer(token: $0,
                                              maxAttempts: 3,
                                              numAttemptsSoFar: 0)
        }
    }

}
