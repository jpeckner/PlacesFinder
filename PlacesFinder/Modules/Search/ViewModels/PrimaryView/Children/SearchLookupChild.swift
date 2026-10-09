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

import Shared
import SwiftDux

enum SearchLookupChild: Equatable {
    case instructions(SearchInstructionsProps)
    case progress(SearchProgressViewProps)
    case results(SearchResultsViewProps)
    case noResults(SearchNoResultsFoundProps)
    case failure(SearchRetryProps)
}

// MARK: SearchLookupChildBuilder

// sourcery: AutoMockable
protocol SearchLookupChildBuilderProtocol {
    func buildChild(loadState: Search.LoadState,
                    appSkin: AppSkin,
                    locationUpdateRequestBlock: @escaping LocationUpdateRequestBlock) -> SearchLookupChild
}

class SearchLookupChildBuilder: SearchLookupChildBuilderProtocol {

    private let actionPrism: SearchActivityActionPrismProtocol
    private let instructionsPropsBuilder: SearchInstructionsPropsBuilderProtocol
    private let resultsPropsBuilder: SearchResultsViewPropsBuilderProtocol
    private let noResultsFoundPropsBuilder: SearchNoResultsFoundPropsBuilderProtocol
    private let retryPropsBuilder: SearchRetryPropsBuilderProtocol

    init(actionPrism: SearchActivityActionPrismProtocol,
         instructionsPropsBuilder: SearchInstructionsPropsBuilderProtocol,
         resultsPropsBuilder: SearchResultsViewPropsBuilderProtocol,
         noResultsFoundPropsBuilder: SearchNoResultsFoundPropsBuilderProtocol,
         retryPropsBuilder: SearchRetryPropsBuilderProtocol) {
        self.actionPrism = actionPrism
        self.instructionsPropsBuilder = instructionsPropsBuilder
        self.resultsPropsBuilder = resultsPropsBuilder
        self.noResultsFoundPropsBuilder = noResultsFoundPropsBuilder
        self.retryPropsBuilder = retryPropsBuilder
    }

    func buildChild(loadState: Search.LoadState,
                    appSkin: AppSkin,
                    locationUpdateRequestBlock: @escaping LocationUpdateRequestBlock) -> SearchLookupChild {
        switch loadState {
        case .idle:
            let instructionsProps = instructionsPropsBuilder.buildProps(colorings: appSkin.colorings.standard)
            return .instructions(instructionsProps)

        case .locationRequested,
             .initialPageRequested:
            let progressProps = SearchProgressViewProps(colorings: appSkin.colorings.searchProgress)
            return .progress(progressProps)

        case let .pagesReceived(submittedParams, _, numPagesReceived, allEntities, tokenContainer):
            return .results(resultsPropsBuilder.buildProps(
                submittedParams: submittedParams,
                allEntities: allEntities,
                colorings: appSkin.colorings.searchResults,
                numPagesReceived: numPagesReceived,
                tokenContainer: tokenContainer,
                locationUpdateRequestBlock: locationUpdateRequestBlock
            ))

        case .noResultsFound:
            let noResultsProps = noResultsFoundPropsBuilder.buildProps(colorings: appSkin.colorings.standard)
            return .noResults(noResultsProps)

        case let .failure(submittedParams, _):
            let retryAction = actionPrism.initialRequestAction(searchParams: submittedParams,
                                                               locationUpdateRequestBlock: locationUpdateRequestBlock)
            return .failure(retryPropsBuilder.buildProps(colorings: appSkin.colorings.searchCTA,
                                                         retryAction: .searchActivity(retryAction)))
        }
    }

}
