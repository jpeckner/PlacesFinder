//
//  SearchLookupChild.swift
//  PlacesFinder
//
//  Created by Justin Peckner.
//  Copyright © 2020 Justin Peckner. All rights reserved.
//

import Shared
import SwiftDux

enum SearchLookupChild: Equatable {
    case instructions(SearchInstructionsViewModel)
    case progress
    case results(SearchResultsViewModel)
    case noResults(SearchNoResultsFoundViewModel)
    case failure(SearchRetryViewModel)
}

// MARK: SearchLookupChildBuilder

protocol SearchLookupChildBuilderProtocol: AutoMockable {
    func buildChild(_ store: DispatchingStoreProtocol,
                    actionPrism: SearchActionPrismProtocol,
                    loadState: SearchLoadState,
                    appCopyContent: AppCopyContent,
                    locationUpdateRequestBlock: @escaping LocationUpdateRequestBlock) -> SearchLookupChild
}

class SearchLookupChildBuilder: SearchLookupChildBuilderProtocol {

    private let instructionsViewModelBuilder: SearchInstructionsViewModelBuilderProtocol
    private let resultsViewModelBuilder: SearchResultsViewModelBuilderProtocol
    private let noResultsFoundViewModelBuilder: SearchNoResultsFoundViewModelBuilderProtocol
    private let retryViewModelBuilder: SearchRetryViewModelBuilderProtocol

    init(instructionsViewModelBuilder: SearchInstructionsViewModelBuilderProtocol,
         resultsViewModelBuilder: SearchResultsViewModelBuilderProtocol,
         noResultsFoundViewModelBuilder: SearchNoResultsFoundViewModelBuilderProtocol,
         retryViewModelBuilder: SearchRetryViewModelBuilderProtocol) {
        self.instructionsViewModelBuilder = instructionsViewModelBuilder
        self.resultsViewModelBuilder = resultsViewModelBuilder
        self.noResultsFoundViewModelBuilder = noResultsFoundViewModelBuilder
        self.retryViewModelBuilder = retryViewModelBuilder
    }

    func buildChild(_ store: DispatchingStoreProtocol,
                    actionPrism: SearchActionPrismProtocol,
                    loadState: SearchLoadState,
                    appCopyContent: AppCopyContent,
                    locationUpdateRequestBlock: @escaping LocationUpdateRequestBlock) -> SearchLookupChild {
        switch loadState {
        case .idle:
            let instructionsViewModel = instructionsViewModelBuilder.buildViewModel(
                copyContent: appCopyContent.searchInstructions
            )
            return .instructions(instructionsViewModel)
        case .locationRequested,
             .initialPageRequested:
            return .progress
        case let .pagesReceived(submittedParams, _, allEntities, tokenContainer):
            return .results(resultsViewModelBuilder.buildViewModel(
                submittedParams: submittedParams,
                allEntities: allEntities,
                tokenContainer: tokenContainer,
                resultsCopyContent: appCopyContent.searchResults,
                locationUpdateRequestBlock: locationUpdateRequestBlock
            ))
        case .noResultsFound:
            let noResultsViewModel = noResultsFoundViewModelBuilder.buildViewModel(appCopyContent.searchNoResults)
            return .noResults(noResultsViewModel)
        case let .failure(submittedParams, _):
            return .failure(retryViewModelBuilder.buildViewModel(appCopyContent.searchRetry) {
                let action = actionPrism.initialRequestAction(submittedParams,
                                                              locationUpdateRequestBlock: locationUpdateRequestBlock)
                store.dispatch(action)
            })
        }
    }

}
