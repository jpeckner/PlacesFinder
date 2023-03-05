//
//  Search+ActivityState.swift
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

typealias SearchPageState = IntermediateStepLoadState<Search.PageRequestError>

typealias SearchPageReducer = IntermediateStepLoadReducer<Search.PageRequestError>

// MARK: Search.ActivityState

extension Search {

    enum LoadState: Equatable {
        case idle

        case locationRequested(SearchParams)

        case initialPageRequested(SearchParams)

        case noResultsFound(SearchParams)

        case pagesReceived(
            params: SearchParams,
            pageState: SearchPageState,
            numPagesReceived: Int,
            allEntities: NonEmptyArray<SearchEntityModel>,
            nextRequestToken: PlaceLookupTokenAttemptsContainer?
        )

        case failure(
            SearchParams,
            underlyingError: IgnoredEquatable<Error>
        )
    }

    struct ActivityState: Equatable {
        let loadState: Search.LoadState
        let inputParams: SearchInputParams
        let detailedEntity: SearchEntityModel?
    }

}

extension Search.ActivityState {

    init() {
        self.loadState = .idle
        self.inputParams = SearchInputParams(
            params: nil,
            barState: .isShowing(isEditing: false)
        )
        self.detailedEntity = nil
    }

    var entities: NonEmptyArray<SearchEntityModel>? {
        switch loadState {
        case let .pagesReceived(_, _, _, allEntities, _):
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

private extension Search.ActivityState {

    var submittedParams: SearchParams? {
        switch loadState {
        case let .locationRequested(params),
             let .initialPageRequested(params),
             let .noResultsFound(params),
             let .pagesReceived(params, _, _, _, _),
             let .failure(params, _):
            return params
        case .idle:
            return nil
        }
    }

    var pageState: SearchPageState? {
        switch loadState {
        case let .pagesReceived(_, pageState, _, _, _):
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

extension Search {

    enum ActivityReducer {

        static func reduce(action: Search.ActivityAction,
                           currentState: Search.ActivityState) -> Search.ActivityState {
            switch action {
            case .startInitialRequest,
                 .startSubsequentRequest:
                return currentState
            case let .locationRequested(submittedParams):
                return Search.ActivityState(
                    loadState: .locationRequested(submittedParams),
                    inputParams: SearchInputParams(
                        params: submittedParams,
                        barState: .isShowing(isEditing: false)
                    ),
                    detailedEntity: nil
                )
            case let .initialPageRequested(submittedParams):
                return Search.ActivityState(
                    loadState: .initialPageRequested(submittedParams),
                    inputParams: currentState.inputParams,
                    detailedEntity: nil
                )
            case let .noResultsFound(submittedParams):
                return Search.ActivityState(
                    loadState: .noResultsFound(submittedParams),
                    inputParams: currentState.inputParams,
                    detailedEntity: nil
                )
            case let .updateRequestStatus(params, pageAction):
                return reduceUpdateRequestStatus(currentState: currentState,
                                                 params: params,
                                                 pageAction: pageAction)
            case let .failure(submittedParams, searchError):
                return Search.ActivityState(
                    loadState: .failure(submittedParams, underlyingError: searchError),
                    inputParams: currentState.inputParams,
                    detailedEntity: nil
                )
            case let .updateInputEditing(action):
                return reduceUpdateInputEditing(currentState: currentState,
                                                action: action)
            case let .detailedEntity(entity):
                return Search.ActivityState(
                    loadState: currentState.loadState,
                    inputParams: currentState.inputParams,
                    detailedEntity: entity
                )
            case .removeDetailedEntity:
                return Search.ActivityState(
                    loadState: currentState.loadState,
                    inputParams: currentState.inputParams,
                    detailedEntity: nil
                )
            }
        }

        private static func reduceUpdateRequestStatus(
            currentState: Search.ActivityState,
            params: Search.ActivityAction.UpdateRequestStatusParams,
            pageAction: IntermediateStepLoadAction<Search.PageRequestError>
        ) -> Search.ActivityState {
            let newPageState = SearchPageReducer.reduce(action: pageAction,
                                                        currentState: currentState.pageState)
            let loadState: Search.LoadState = .pagesReceived(params: params.searchParams,
                                                             pageState: newPageState,
                                                             numPagesReceived: params.numPagesReceived,
                                                             allEntities: params.allEntities,
                                                             nextRequestToken: params.nextRequestToken)
            let inputParams = params.numPagesReceived == 1 ?
                // Ensure that the search bar is visible right after starting a new search
                SearchInputParams(
                    params: currentState.inputParams.params,
                    barState: .isShowing(isEditing: false)
                )
                :
                SearchInputParams(
                    params: currentState.inputParams.params,
                    barState: .isHidden
                )

            return Search.ActivityState(
                loadState: loadState,
                inputParams: inputParams,
                detailedEntity: currentState.detailedEntity
            )
        }

        private static func reduceUpdateInputEditing(currentState: Search.ActivityState,
                                                     action: SearchBarEditEvent) -> Search.ActivityState {
            let inputParams: SearchInputParams
            switch action {
            case .beganEditing:
                inputParams = SearchInputParams(
                    params: currentState.inputParams.params,
                    barState: .isShowing(isEditing: true)
                )
            case .clearedInput:
                inputParams = SearchInputParams(
                    params: nil,
                    barState: .isShowing(isEditing: true)
                )
            case .endedEditing:
                inputParams = SearchInputParams(
                    params: currentState.submittedParams,
                    barState: .isHidden
                )
            }

            return Search.ActivityState(
                loadState: currentState.loadState,
                inputParams: inputParams,
                detailedEntity: currentState.detailedEntity
            )
        }

    }

}
