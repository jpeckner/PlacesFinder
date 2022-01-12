//
//  SearchAction.swift
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

enum SearchPageRequestError: Error, Equatable {
    case cannotRetryRequest(underlyingError: IgnoredEquatable<Error>)
    case canRetryRequest(underlyingError: IgnoredEquatable<Error>)
}

enum SearchAction: Action, Equatable {
    // Load state
    case locationRequested(SearchParams)

    case initialPageRequested(SearchParams)

    case noResultsFound(SearchParams)

    case subsequentRequest(
        SearchParams,
        pageAction: IntermediateStepLoadAction<SearchPageRequestError>,
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

// MARK: SearchActionCreator

struct SearchActionCreatorDependencies {
    let placeLookupService: PlaceLookupServiceProtocol
    let searchEntityModelBuilder: SearchEntityModelBuilderProtocol
}

protocol SearchActionCreatorProtocol: ResettableAutoMockable {
    static func requestInitialPage(_ dependencies: SearchActionCreatorDependencies,
                                   searchParams: SearchParams,
                                   locationUpdateRequestBlock: @escaping LocationUpdateRequestBlock) -> Action

    static func requestSubsequentPage(_ dependencies: SearchActionCreatorDependencies,
                                      searchParams: SearchParams,
                                      previousResults: NonEmptyArray<SearchEntityModel>,
                                      tokenContainer: PlaceLookupTokenAttemptsContainer) -> Action
}

enum SearchActionCreator: SearchActionCreatorProtocol {}

extension SearchActionCreator {

    static func requestInitialPage(_ dependencies: SearchActionCreatorDependencies,
                                   searchParams: SearchParams,
                                   locationUpdateRequestBlock: @escaping LocationUpdateRequestBlock) -> Action {
        return AppAsyncAction { dispatch, stateReceiverBlock in
            dispatch(SearchAction.locationRequested(searchParams))

            stateReceiverBlock { appState in
                requestLocation(appState.searchPreferencesState,
                                dependencies: dependencies,
                                searchParams: searchParams,
                                locationUpdateRequestBlock: locationUpdateRequestBlock,
                                dispatch: dispatch)
            }
        }
    }

    private static func requestLocation(_ preferencesState: SearchPreferencesState,
                                        dependencies: SearchActionCreatorDependencies,
                                        searchParams: SearchParams,
                                        locationUpdateRequestBlock: @escaping LocationUpdateRequestBlock,
                                        dispatch: @escaping DispatchFunction) {
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
                                                  dependencies: SearchActionCreatorDependencies,
                                                  searchParams: SearchParams,
                                                  dispatch: @escaping DispatchFunction) {
        do {
            let placeLookupService = dependencies.placeLookupService
            let initialRequestToken = try placeLookupService.buildInitialPageRequestToken(placeLookupParams)

            dispatch(SearchAction.initialPageRequested(searchParams))
            placeLookupService.requestPage(initialRequestToken) { result in
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

    private static func dispatchInitialPageSuccess(_ dependencies: SearchActionCreatorDependencies,
                                                   searchParams: SearchParams,
                                                   lookupResponse: PlaceLookupResponse,
                                                   dispatch: @escaping DispatchFunction) {
        let entityModels = dependencies.searchEntityModelBuilder.buildEntityModels(lookupResponse.page.entities)
        guard let allEntities = NonEmptyArray(entityModels) else {
            dispatch(SearchAction.noResultsFound(searchParams))
            return
        }

        dispatch(SearchAction.subsequentRequest(
            searchParams,
            pageAction: .success,
            allEntities: allEntities,
            nextRequestToken: tokenContainer(for: lookupResponse)
        ))
    }

    private static func dispatchInitialPageFailure(_ searchParams: SearchParams,
                                                   underlyingError: Error,
                                                   dispatch: @escaping DispatchFunction) {
        dispatch(SearchAction.failure(searchParams,
                                      underlyingError: IgnoredEquatable(underlyingError)))
    }

}

extension SearchActionCreator {

    static func requestSubsequentPage(_ dependencies: SearchActionCreatorDependencies,
                                      searchParams: SearchParams,
                                      previousResults: NonEmptyArray<SearchEntityModel>,
                                      tokenContainer: PlaceLookupTokenAttemptsContainer) -> Action {
        return AppAsyncAction { dispatch, _ in
            dispatch(SearchAction.subsequentRequest(
                searchParams,
                pageAction: .inProgress,
                allEntities: previousResults,
                nextRequestToken: nil
            ))

            dependencies.placeLookupService.requestPage(tokenContainer.token) { result in
                switch result {
                case let .success(lookupResponse):
                    dispatchSubsequentPageSuccess(previousResults,
                                                  lookupResponse: lookupResponse,
                                                  dependencies: dependencies,
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

    private static func dispatchSubsequentPageSuccess(_ previousResults: NonEmptyArray<SearchEntityModel>,
                                                      lookupResponse: PlaceLookupResponse,
                                                      dependencies: SearchActionCreatorDependencies,
                                                      searchParams: SearchParams,
                                                      dispatch: @escaping DispatchFunction) {
        let entityModels = dependencies.searchEntityModelBuilder.buildEntityModels(lookupResponse.page.entities)

        dispatch(SearchAction.subsequentRequest(
            searchParams,
            pageAction: .success,
            allEntities: previousResults.appendedWith(entityModels),
            nextRequestToken: tokenContainer(for: lookupResponse)
        ))
    }

    private static func dispatchSubsequentPageError(_ previousResults: NonEmptyArray<SearchEntityModel>,
                                                    lastRequestTokenContainer: PlaceLookupTokenAttemptsContainer,
                                                    searchParams: SearchParams,
                                                    placeLookupServiceError: PlaceLookupServiceError,
                                                    dispatch: @escaping DispatchFunction) {
        let underlyingError = IgnoredEquatable<Error>(placeLookupServiceError)
        let isRequestRetriable = placeLookupServiceError.isRetriable
        let pageError: SearchPageRequestError = isRequestRetriable ?
            .canRetryRequest(underlyingError: underlyingError)
            :
            .cannotRetryRequest(underlyingError: underlyingError)
        let nextRequestToken = isRequestRetriable ? lastRequestTokenContainer : nil

        dispatch(SearchAction.subsequentRequest(
            searchParams,
            pageAction: .failure(pageError),
            allEntities: previousResults,
            nextRequestToken: nextRequestToken
        ))
    }

}

private extension SearchActionCreator {

    static func tokenContainer(for lookupResponse: PlaceLookupResponse) -> PlaceLookupTokenAttemptsContainer? {
        let nextRequestToken = try? lookupResponse.nextRequestTokenResult?.get()
        return nextRequestToken.map {
            PlaceLookupTokenAttemptsContainer(token: $0,
                                              maxAttempts: 3,
                                              numAttemptsSoFar: 0)
        }
    }

}
