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
        case startInitialRequest(
            dependencies: IgnoredEquatable<ActivityActionCreatorDependencies>,
            searchParams: SearchParams,
            locationUpdateRequestBlock: IgnoredEquatable<LocationUpdateRequestBlock>
        )

        // Load state
        case locationRequested(SearchParams)

        case initialPageRequested(SearchParams)

        case noResultsFound(SearchParams)

        case startSubsequentRequest(
            dependencies: IgnoredEquatable<ActivityActionCreatorDependencies>,
            searchParams: SearchParams,
            previousResults: NonEmptyArray<SearchEntityModel>,
            tokenContainer: PlaceLookupTokenAttemptsContainer
        )

        case subsequentRequest(
            searchParams: SearchParams,
            pageAction: IntermediateStepLoadAction<Search.PageRequestError>,
            allEntities: NonEmptyArray<SearchEntityModel>,
            nextRequestToken: PlaceLookupTokenAttemptsContainer?
        )

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
                        requestLocation(appState.searchPreferencesState,
                                        dependencies: dependencies.value,
                                        searchParams: searchParams,
                                        locationUpdateRequestBlock: locationUpdateRequestBlock.value,
                                        dispatch: dispatch)
                    }))
                }
            }
        }
    }

    private static func requestLocation(_ preferencesState: SearchPreferencesState,
                                        dependencies: Search.ActivityActionCreatorDependencies,
                                        searchParams: SearchParams,
                                        locationUpdateRequestBlock: @escaping LocationUpdateRequestBlock,
                                        dispatch: @escaping DispatchFunction<Search.Action>) {
        locationUpdateRequestBlock { result in
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

        dispatch(.searchActivity(.subsequentRequest(
            searchParams: searchParams,
            pageAction: .success,
            allEntities: allEntities,
            nextRequestToken: tokenContainer(for: lookupResponse)
        )))
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
                        searchParams,
                        previousResults,
                        tokenContainer
                    )) = action
                    else {
                        next(action)
                        return
                    }

                    dispatch(.searchActivity(.subsequentRequest(
                        searchParams: searchParams,
                        pageAction: .inProgress,
                        allEntities: previousResults,
                        nextRequestToken: nil
                    )))

                    Task {
                        let result = await dependencies.value.placeLookupService.requestPage(
                            requestToken: tokenContainer.token
                        )

                        switch result {
                        case let .success(lookupResponse):
                            dispatchSubsequentPageSuccess(previousResults,
                                                          lookupResponse: lookupResponse,
                                                          dependencies: dependencies.value,
                                                          searchParams: searchParams,
                                                          dispatch: dispatch)
                        case let .failure(error):
                            dispatchSubsequentPageError(previousResults,
                                                        lastRequestTokenContainer: tokenContainer,
                                                        searchParams: searchParams,
                                                        placeLookupServiceError: error,
                                                        dispatch: dispatch)
                        }
                    }
                }
            }
        }
    }

    private static func dispatchSubsequentPageSuccess(_ previousResults: NonEmptyArray<SearchEntityModel>,
                                                      lookupResponse: PlaceLookupResponse,
                                                      dependencies: Search.ActivityActionCreatorDependencies,
                                                      searchParams: SearchParams,
                                                      dispatch: @escaping DispatchFunction<Search.Action>) {
        let entityModels = dependencies.searchEntityModelBuilder.buildEntityModels(lookupResponse.page.entities)

        dispatch(.searchActivity(.subsequentRequest(
            searchParams: searchParams,
            pageAction: .success,
            allEntities: previousResults.appendedWith(entityModels),
            nextRequestToken: tokenContainer(for: lookupResponse)
        )))
    }

    private static func dispatchSubsequentPageError(_ previousResults: NonEmptyArray<SearchEntityModel>,
                                                    lastRequestTokenContainer: PlaceLookupTokenAttemptsContainer,
                                                    searchParams: SearchParams,
                                                    placeLookupServiceError: PlaceLookupServiceError,
                                                    dispatch: @escaping DispatchFunction<Search.Action>) {
        let underlyingError = IgnoredEquatable<Error>(placeLookupServiceError)
        let isRequestRetriable = placeLookupServiceError.isRetriable
        let pageError: Search.PageRequestError = isRequestRetriable ?
            .canRetryRequest(underlyingError: underlyingError)
            :
            .cannotRetryRequest(underlyingError: underlyingError)
        let nextRequestToken = isRequestRetriable ? lastRequestTokenContainer : nil

        dispatch(.searchActivity(.subsequentRequest(
            searchParams: searchParams,
            pageAction: .failure(pageError),
            allEntities: previousResults,
            nextRequestToken: nextRequestToken
        )))
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
