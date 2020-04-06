//
//  SearchLookupChild.swift
//  PlacesFinder
//
//  Created by Justin Peckner.
//  Copyright © 2020 Justin Peckner. All rights reserved.
//

import Foundation

enum SearchLookupChild {
    case instructions(SearchInstructionsViewModel)
    case progress
    case results(SearchResultsViewModel)
    case noResults(SearchNoResultsFoundViewModel)
    case failure(SearchRetryViewModel)
}
