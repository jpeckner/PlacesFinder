//
//  SearchLookupViewModel.swift
//  PlacesFinder
//
//  Created by Justin Peckner.
//  Copyright © 2020 Justin Peckner. All rights reserved.
//

import Foundation
import Shared
import SwiftDux

struct SearchLookupViewModel {
    enum Child {
        case instructions(SearchInstructionsViewModel)
        case progress
        case results(SearchResultsViewModel, refreshAction: Action, nextRequestAction: Action?)
        case noResults(SearchNoResultsFoundViewModel)
        case failure(SearchRetryViewModel)
    }

    let searchInputViewModel: SearchInputViewModel
    let child: Child
}

extension SearchLookupViewModel {

    init(searchState: SearchState,
         store: DispatchingStoreProtocol,
         actionPrism: SearchActionPrismProtocol,
         copyFormatter: SearchCopyFormatterProtocol,
         appCopyContent: AppCopyContent,
         locationUpdateRequestBlock: @escaping LocationUpdateRequestBlock) {
        let contentViewModel = SearchInputContentViewModel(keywords: searchState.inputParams.params?.keywords,
                                                           isEditing: searchState.inputParams.isEditing,
                                                           copyContent: appCopyContent.searchInput)

        let callbacks = SearchInputViewModel.Callbacks(isEditing: { editAction in
            let action = actionPrism.updateEditingAction(editAction)
            store.dispatch(action)
        }, lookup: { params in
            let action = actionPrism.initialRequestAction(params,
                                                          locationUpdateRequestBlock: locationUpdateRequestBlock)
            store.dispatch(action)
        })

        self.searchInputViewModel = SearchInputViewModel(content: contentViewModel,
                                                         callbacks: callbacks)

        self.child = Child(loadState: searchState.loadState,
                           store: store,
                           actionPrism: actionPrism,
                           copyFormatter: copyFormatter,
                           appCopyContent: appCopyContent,
                           locationUpdateRequestBlock: locationUpdateRequestBlock)
    }

}

private extension SearchLookupViewModel.Child {

    init(loadState: SearchLoadState,
         store: DispatchingStoreProtocol,
         actionPrism: SearchActionPrismProtocol,
         copyFormatter: SearchCopyFormatterProtocol,
         appCopyContent: AppCopyContent,
         locationUpdateRequestBlock: @escaping LocationUpdateRequestBlock) {
        switch loadState {
        case .idle:
            self = .instructions(SearchInstructionsViewModel(copyContent: appCopyContent.searchInstructions))
        case .locationRequested,
             .initialPageRequested:
            self = .progress
        case let .pagesReceived(submittedParams, _, allEntities, tokenContainer):
            let viewModel = SearchResultsViewModel(allEntities: allEntities,
                                                   actionPrism: actionPrism,
                                                   copyFormatter: copyFormatter,
                                                   resultsCopyContent: appCopyContent.searchResults)
            let refreshAction = actionPrism.initialRequestAction(submittedParams,
                                                                 locationUpdateRequestBlock: locationUpdateRequestBlock)
            let nextRequestAction = tokenContainer.flatMap {
                try? actionPrism.subsequentRequestAction(submittedParams,
                                                         allEntities: allEntities,
                                                         tokenContainer: $0)
            }

            self = .results(viewModel,
                            refreshAction: refreshAction,
                            nextRequestAction: nextRequestAction)
        case .noResultsFound:
            self = .noResults(SearchNoResultsFoundViewModel(copyContent: appCopyContent.searchNoResults))
        case let .failure(submittedParams, _):
            self = .failure(SearchRetryViewModel(copyContent: appCopyContent.searchRetry) {
                let action = actionPrism.initialRequestAction(submittedParams,
                                                              locationUpdateRequestBlock: locationUpdateRequestBlock)
                store.dispatch(action)
            })
        }
    }

}
