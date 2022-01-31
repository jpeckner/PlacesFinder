//
//  SearchDetailsViewContext.swift
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

enum SearchDetailsViewContext: Equatable {
    case detailedEntity(SearchDetailsViewModel)
    case firstListedEntity(SearchDetailsViewModel)
}

// MARK: SearchDetailsViewContextBuilder

protocol SearchDetailsViewContextBuilderProtocol: AutoMockable {
    func buildViewContext(_ searchActivityState: SearchActivityState,
                          appCopyContent: AppCopyContent) -> SearchDetailsViewContext?
}

class SearchDetailsViewContextBuilder: SearchDetailsViewContextBuilderProtocol {

    private let detailsViewModelBuilder: SearchDetailsViewModelBuilderProtocol

    init(detailsViewModelBuilder: SearchDetailsViewModelBuilderProtocol) {
        self.detailsViewModelBuilder = detailsViewModelBuilder
    }

    func buildViewContext(_ searchActivityState: SearchActivityState,
                          appCopyContent: AppCopyContent) -> SearchDetailsViewContext? {
        return
            searchActivityState.detailedEntity.map { entity in
                let viewModel = detailsViewModelBuilder.buildViewModel(entity,
                                                                       resultsCopyContent: appCopyContent.searchResults)
                return .detailedEntity(viewModel)
            }
            ?? searchActivityState.entities?.value.first.map { entity in
                let viewModel = detailsViewModelBuilder.buildViewModel(entity,
                                                                       resultsCopyContent: appCopyContent.searchResults)
                return .firstListedEntity(viewModel)
            }
    }

}
