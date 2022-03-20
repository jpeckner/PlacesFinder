//
//  SearchLookupChild.swift
//  PlacesFinder
//
//  Copyright (c) 2020 Justin Peckner
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

import Combine
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
    func buildChild(_ loadState: SearchLoadState,
                    appCopyContent: AppCopyContent,
                    locationUpdateRequestBlock: @escaping LocationUpdateRequestBlock) -> SearchLookupChild
}

class SearchLookupChildBuilder: SearchLookupChildBuilderProtocol {

    private let actionSubscriber: AnySubscriber<AppAction, Never>
    private let actionPrism: SearchActivityActionPrismProtocol
    private let instructionsViewModelBuilder: SearchInstructionsViewModelBuilderProtocol
    private let resultsViewModelBuilder: SearchResultsViewModelBuilderProtocol
    private let noResultsFoundViewModelBuilder: SearchNoResultsFoundViewModelBuilderProtocol
    private let retryViewModelBuilder: SearchRetryViewModelBuilderProtocol

    init(actionSubscriber: AnySubscriber<AppAction, Never>,
         actionPrism: SearchActivityActionPrismProtocol,
         instructionsViewModelBuilder: SearchInstructionsViewModelBuilderProtocol,
         resultsViewModelBuilder: SearchResultsViewModelBuilderProtocol,
         noResultsFoundViewModelBuilder: SearchNoResultsFoundViewModelBuilderProtocol,
         retryViewModelBuilder: SearchRetryViewModelBuilderProtocol) {
        self.actionSubscriber = actionSubscriber
        self.actionPrism = actionPrism
        self.instructionsViewModelBuilder = instructionsViewModelBuilder
        self.resultsViewModelBuilder = resultsViewModelBuilder
        self.noResultsFoundViewModelBuilder = noResultsFoundViewModelBuilder
        self.retryViewModelBuilder = retryViewModelBuilder
    }

    func buildChild(_ loadState: SearchLoadState,
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
                actionSubscriber: actionSubscriber,
                locationUpdateRequestBlock: locationUpdateRequestBlock
            ))
        case .noResultsFound:
            let noResultsViewModel = noResultsFoundViewModelBuilder.buildViewModel(appCopyContent.searchNoResults)
            return .noResults(noResultsViewModel)
        case let .failure(submittedParams, _):
            let actionSubscriber = self.actionSubscriber
            let actionPrism = self.actionPrism
            return .failure(retryViewModelBuilder.buildViewModel(appCopyContent.searchRetry) {
                let action = actionPrism.initialRequestAction(submittedParams,
                                                              locationUpdateRequestBlock: locationUpdateRequestBlock)
                _ = actionSubscriber.receive(action)
            })
        }
    }

}
