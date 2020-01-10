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
         copyContent: SearchInputCopyContent,
         child: Child) {
        self.searchInputViewModel = SearchInputViewModel(inputKeywords: searchState.submittedParams?.keywords,
                                                         copyContent: copyContent)
        self.child = child
    }

}
