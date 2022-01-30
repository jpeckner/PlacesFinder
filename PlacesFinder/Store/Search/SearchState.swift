//
//  SearchState.swift
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

import Shared
import SwiftDux

// MARK: SearchPagesReceivedState

typealias SearchPageState = IntermediateStepLoadState<SearchPageRequestError>

typealias SearchPageReducer = IntermediateStepLoadReducer<SearchPageRequestError>

// MARK: SearchState

enum SearchLoadState: Equatable {
    case idle

    case locationRequested(SearchParams)

    case initialPageRequested(SearchParams)

    case noResultsFound(SearchParams)

    case pagesReceived(
        SearchParams,
        pageState: SearchPageState,
        allEntities: NonEmptyArray<SearchEntityModel>,
        nextRequestToken: PlaceLookupTokenAttemptsContainer?
    )

    case failure(
        SearchParams,
        underlyingError: IgnoredEquatable<Error>
    )
}

struct SearchState: Equatable {
    let loadState: SearchLoadState
    let inputParams: SearchInputParams
    let detailedEntity: SearchEntityModel?
}

extension SearchState {

    init() {
        self.loadState = .idle
        self.inputParams = SearchInputParams(params: nil,
                                             isEditing: false)
        self.detailedEntity = nil
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

    var submittedParams: SearchParams? {
        switch loadState {
        case let .locationRequested(params),
             let .initialPageRequested(params),
             let .noResultsFound(params),
             let .pagesReceived(params, _, _, _),
             let .failure(params, _):
            return params
        case .idle:
            return nil
        }
    }

    var pageState: SearchPageState? {
        switch loadState {
        case let .pagesReceived(_, pageState, _, _):
            return pageState
        case .idle,
             .locationRequested,
             .initialPageRequested,
             .noResultsFound,
             .failure:
            return nil
        }
    }

}

// MARK: Reducer

enum SearchReducer {

    // swiftlint:disable function_body_length
    static func reduce(action: Action,
                       currentState: SearchState) -> SearchState {
        guard let searchAction = action as? SearchActivityAction else { return currentState }

        switch searchAction {
        case let .locationRequested(submittedParams):
            return SearchState(loadState: .locationRequested(submittedParams),
                               inputParams: SearchInputParams(params: submittedParams,
                                                              isEditing: false),
                               detailedEntity: nil)
        case let .initialPageRequested(submittedParams):
            return SearchState(loadState: .initialPageRequested(submittedParams),
                               inputParams: currentState.inputParams,
                               detailedEntity: nil)
        case let .noResultsFound(submittedParams):
            return SearchState(loadState: .noResultsFound(submittedParams),
                               inputParams: currentState.inputParams,
                               detailedEntity: nil)
        case let .subsequentRequest(submittedParams, pageAction, allEntities, nextRequestToken):
            let newPageState = SearchPageReducer.reduce(action: pageAction,
                                                        currentState: currentState.pageState)
            let loadState: SearchLoadState = .pagesReceived(submittedParams,
                                                            pageState: newPageState,
                                                            allEntities: allEntities,
                                                            nextRequestToken: nextRequestToken)

            return SearchState(loadState: loadState,
                               inputParams: currentState.inputParams,
                               detailedEntity: currentState.detailedEntity)
        case let .failure(submittedParams, searchError):
            return SearchState(loadState: .failure(submittedParams, underlyingError: searchError),
                               inputParams: currentState.inputParams,
                               detailedEntity: nil)
        case let .updateInputEditing(action):
            return SearchState(loadState: currentState.loadState,
                               inputParams: buildInputParams(currentState, action: action),
                               detailedEntity: currentState.detailedEntity)
        case let .detailedEntity(entity):
            return SearchState(loadState: currentState.loadState,
                               inputParams: currentState.inputParams,
                               detailedEntity: entity)
        case .removeDetailedEntity:
            return SearchState(loadState: currentState.loadState,
                               inputParams: currentState.inputParams,
                               detailedEntity: nil)

        }
    }
    // swiftlint:enable function_body_length

    private static func buildInputParams(_ currentState: SearchState,
                                         action: SearchBarEditEvent) -> SearchInputParams {
        switch action {
        case .beganEditing:
            return SearchInputParams(params: currentState.inputParams.params,
                                     isEditing: true)
        case .clearedInput:
            return SearchInputParams(params: nil,
                                     isEditing: true)
        case .endedEditing:
            return SearchInputParams(params: currentState.submittedParams,
                                     isEditing: false)
        }
    }

}
