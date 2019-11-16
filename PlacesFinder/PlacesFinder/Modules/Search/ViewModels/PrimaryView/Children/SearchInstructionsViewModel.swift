//
//  SearchInstructionsViewModel.swift
//  PlacesFinder
//
//  Created by Justin Peckner.
//  Copyright © 2019 Justin Peckner. All rights reserved.
//

import Foundation

struct SearchInstructionsViewModel {
    let infoViewModel: StaticInfoViewModel
    let resultsSourceCopy: String
}

@available(iOS 13.0, *)
class SearchInstructionsViewModelSUI {
    @Published var infoViewModel: StaticInfoViewModel
    @Published var resultsSourceCopy: String

    init(infoViewModel: StaticInfoViewModel,
         resultsSourceCopy: String) {
        self.infoViewModel = infoViewModel
        self.resultsSourceCopy = resultsSourceCopy
    }
}
