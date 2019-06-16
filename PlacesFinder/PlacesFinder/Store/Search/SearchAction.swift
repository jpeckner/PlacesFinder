//
//  SearchAction.swift
//  PlacesFinder
//
//  Created by Justin Peckner.
//  Copyright © 2018 Justin Peckner. All rights reserved.
//

import Foundation
import Shared
import SwiftDux

enum SearchPageRequestError: Error, Equatable {
    case cannotRetryRequest(underlyingError: IgnoredEquatable<Error>)
    case canRetryRequest(underlyingError: IgnoredEquatable<Error>)
}

enum SearchAction: Action, Equatable {
    case locationRequested(SearchSubmittedParams)

    case initialPageRequested(SearchSubmittedParams)

    case noResultsFound(SearchSubmittedParams)

    case subsequentRequest(
        SearchSubmittedParams,
        pageAction: IntermediateStepLoadAction<SearchPageRequestError>,
        allEntities: NonEmptyArray<SearchEntityModel>,
        nextRequestToken: PlaceLookupTokenAttemptsContainer?
    )

    case detailedEntity(SearchDetailsModel)

    case removeDetailedEntity

    case failure(
        SearchSubmittedParams,
        underlyingError: IgnoredEquatable<Error>
    )
}

// MARK: SearchActionCreator

struct SearchActionCreatorDependencies {
    let placeLookupService: PlaceLookupServiceProtocol
    let searchEntityModelBuilder: SearchEntityModelBuilderProtocol
}

protocol SearchActionCreatorProtocol: ResettableAutoMockable {
    static func requestInitialPage(_ dependencies: SearchActionCreatorDependencies,
                                   submittedParams: SearchSubmittedParams,
                                   locationUpdateRequestBlock: @escaping LocationUpdateRequestBlock) -> Action

    static func requestSubsequentPage(_ dependencies: SearchActionCreatorDependencies,
                                      submittedParams: SearchSubmittedParams,
                                      previousResults: NonEmptyArray<SearchEntityModel>,
                                      tokenContainer: PlaceLookupTokenAttemptsContainer) -> Action
}

enum SearchActionCreator: SearchActionCreatorProtocol {}

extension SearchActionCreator {

    static func requestInitialPage(_ dependencies: SearchActionCreatorDependencies,
                                   submittedParams: SearchSubmittedParams,
                                   locationUpdateRequestBlock: @escaping LocationUpdateRequestBlock) -> Action {
        return AppAsyncAction { dispatch, stateReceiverBlock in
            dispatch(SearchAction.locationRequested(submittedParams))

            stateReceiverBlock { appState in
                requestLocation(appState.searchPreferencesState,
                                dependencies: dependencies,
                                submittedParams: submittedParams,
                                locationUpdateRequestBlock: locationUpdateRequestBlock,
                                dispatch: dispatch)
            }
        }
    }

    private static func requestLocation(_ preferencesState: SearchPreferencesState,
                                        dependencies: SearchActionCreatorDependencies,
                                        submittedParams: SearchSubmittedParams,
                                        locationUpdateRequestBlock: @escaping LocationUpdateRequestBlock,
                                        dispatch: @escaping DispatchFunction) {
        locationUpdateRequestBlock { result in
            switch result {
            case let .success(coordinate):
                let lookupParams = PlaceLookupParams(keywords: submittedParams.keywords,
                                                     coordinate: coordinate,
                                                     radius: preferencesState.distance.distanceType.measurement,
                                                     sorting: preferencesState.sorting)

                performInitialPageRequest(lookupParams,
                                          dependencies: dependencies,
                                          submittedParams: submittedParams,
                                          dispatch: dispatch)
            case let .failure(error):
                dispatchInitialPageFailure(submittedParams,
                                           underlyingError: error,
                                           dispatch: dispatch)
            }
        }
    }

    private static func performInitialPageRequest(_ placeLookupParams: PlaceLookupParams,
                                                  dependencies: SearchActionCreatorDependencies,
                                                  submittedParams: SearchSubmittedParams,
                                                  dispatch: @escaping DispatchFunction) {
        do {
            let placeLookupService = dependencies.placeLookupService
            let initialRequestToken = try placeLookupService.buildInitialPageRequestToken(placeLookupParams)

            dispatch(SearchAction.initialPageRequested(submittedParams))
            placeLookupService.requestPage(initialRequestToken) { result in
                switch result {
                case let .success(lookupResponse):
                    dispatchInitialPageSuccess(dependencies,
                                               submittedParams: submittedParams,
                                               lookupResponse: lookupResponse,
                                               dispatch: dispatch)
                case let .failure(error):
                    dispatchInitialPageFailure(submittedParams,
                                               underlyingError: error,
                                               dispatch: dispatch)
                }
            }
        } catch {
            dispatchInitialPageFailure(submittedParams,
                                       underlyingError: error,
                                       dispatch: dispatch)
        }
    }

    private static func dispatchInitialPageSuccess(_ dependencies: SearchActionCreatorDependencies,
                                                   submittedParams: SearchSubmittedParams,
                                                   lookupResponse: PlaceLookupResponse,
                                                   dispatch: @escaping DispatchFunction) {
        let entityModels = dependencies.searchEntityModelBuilder.buildEntityModels(lookupResponse.page.entities)
        guard let allEntities = NonEmptyArray(entityModels) else {
            dispatch(SearchAction.noResultsFound(submittedParams))
            return
        }

        dispatch(SearchAction.subsequentRequest(
            submittedParams,
            pageAction: .success,
            allEntities: allEntities,
            nextRequestToken: tokenContainer(for: lookupResponse)
        ))
    }

    private static func dispatchInitialPageFailure(_ submittedParams: SearchSubmittedParams,
                                                   underlyingError: Error,
                                                   dispatch: @escaping DispatchFunction) {
        dispatch(SearchAction.failure(submittedParams,
                                      underlyingError: IgnoredEquatable(underlyingError)))
    }

}

extension SearchActionCreator {

    static func requestSubsequentPage(_ dependencies: SearchActionCreatorDependencies,
                                      submittedParams: SearchSubmittedParams,
                                      previousResults: NonEmptyArray<SearchEntityModel>,
                                      tokenContainer: PlaceLookupTokenAttemptsContainer) -> Action {
        return AppAsyncAction { dispatch, _ in
            dispatch(SearchAction.subsequentRequest(
                submittedParams,
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
                                                  submittedParams: submittedParams,
                                                  dispatch: dispatch)
                case let .failure(error):
                    dispatchSubsequentPageError(previousResults,
                                                lastRequestTokenContainer: tokenContainer,
                                                submittedParams: submittedParams,
                                                placeLookupServiceError: error,
                                                dispatch: dispatch)
                }
            }
        }
    }

    private static func dispatchSubsequentPageSuccess(_ previousResults: NonEmptyArray<SearchEntityModel>,
                                                      lookupResponse: PlaceLookupResponse,
                                                      dependencies: SearchActionCreatorDependencies,
                                                      submittedParams: SearchSubmittedParams,
                                                      dispatch: @escaping DispatchFunction) {
        let entityModels = dependencies.searchEntityModelBuilder.buildEntityModels(lookupResponse.page.entities)

        dispatch(SearchAction.subsequentRequest(
            submittedParams,
            pageAction: .success,
            allEntities: previousResults.appendedWith(entityModels),
            nextRequestToken: tokenContainer(for: lookupResponse)
        ))
    }

    private static func dispatchSubsequentPageError(_ previousResults: NonEmptyArray<SearchEntityModel>,
                                                    lastRequestTokenContainer: PlaceLookupTokenAttemptsContainer,
                                                    submittedParams: SearchSubmittedParams,
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
            submittedParams,
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
