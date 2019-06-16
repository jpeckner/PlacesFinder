//
//  SearchState.swift
//  PlacesFinder
//
//  Created by Justin Peckner.
//  Copyright © 2018 Justin Peckner. All rights reserved.
//

import Shared
import SwiftDux

// MARK: SearchPagesReceivedState

typealias SearchPageState = IntermediateStepLoadState<SearchPageRequestError>

typealias SearchPageReducer = IntermediateStepLoadReducer<SearchPageRequestError>

// MARK: SearchState

enum SearchLoadState: Equatable {
    case idle

    case locationRequested(SearchSubmittedParams)

    case initialPageRequested(SearchSubmittedParams)

    case noResultsFound(SearchSubmittedParams)

    case pagesReceived(
        SearchSubmittedParams,
        pageState: SearchPageState,
        allEntities: NonEmptyArray<SearchEntityModel>,
        nextRequestToken: PlaceLookupTokenAttemptsContainer?
    )

    case failure(
        SearchSubmittedParams,
        underlyingError: IgnoredEquatable<Error>
    )
}

struct SearchState: Equatable {
    let loadState: SearchLoadState
    let detailedEntity: SearchDetailsModel?
}

extension SearchState {

    init() {
        self.loadState = .idle
        self.detailedEntity = nil
    }

    var submittedParams: SearchSubmittedParams? {
        switch loadState {
        case .idle:
            return nil
        case let .locationRequested(params),
             let .initialPageRequested(params),
             let .noResultsFound(params),
             let .pagesReceived(params, _, _, _),
             let .failure(params, _):
            return params
        }
    }

    var entities: NonEmptyArray<SearchEntityModel>? {
        switch loadState {
        case let .pagesReceived(_, _, allEntities, _):
            return allEntities
        case .idle,
             .locationRequested,
             .initialPageRequested,
             .noResultsFound,
             .failure:
            return nil
        }
    }

}

private extension SearchState {

    var pageState: SearchPageState? {
        guard case let .pagesReceived(_, pageState, _, _) = loadState else { return nil }
        return pageState
    }

}

// MARK: Reducer

enum SearchReducer {

    static func reduce(action: Action,
                       currentState: SearchState) -> SearchState {
        guard let searchAction = action as? SearchAction else { return currentState }

        switch searchAction {
        case let .locationRequested(submittedParams):
            return SearchState(loadState: .locationRequested(submittedParams),
                               detailedEntity: nil)
        case let .initialPageRequested(submittedParams):
            return SearchState(loadState: .initialPageRequested(submittedParams),
                               detailedEntity: nil)
        case let .noResultsFound(submittedParams):
            return SearchState(loadState: .noResultsFound(submittedParams),
                               detailedEntity: nil)
        case let .subsequentRequest(submittedParams, pageAction, allEntities, nextRequestToken):
            let newPageState = SearchPageReducer.reduce(action: pageAction,
                                                        currentState: currentState.pageState)
            let loadState: SearchLoadState = .pagesReceived(submittedParams,
                                                            pageState: newPageState,
                                                            allEntities: allEntities,
                                                            nextRequestToken: nextRequestToken)

            return SearchState(loadState: loadState,
                               detailedEntity: currentState.detailedEntity)
        case let .detailedEntity(detailsModel):
            return SearchState(loadState: currentState.loadState,
                               detailedEntity: detailsModel)
        case .removeDetailedEntity:
            return SearchState(loadState: currentState.loadState,
                               detailedEntity: nil)
        case let .failure(submittedParams, searchError):
            return SearchState(loadState: .failure(submittedParams, underlyingError: searchError),
                               detailedEntity: nil)
        }
    }

}
