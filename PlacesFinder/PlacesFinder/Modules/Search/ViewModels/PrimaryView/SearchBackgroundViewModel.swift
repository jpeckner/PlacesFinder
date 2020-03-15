//
//  SearchBackgroundViewModel.swift
//  PlacesFinder
//
//  Created by Justin Peckner.
//  Copyright © 2020 Justin Peckner. All rights reserved.
//

import Foundation

struct SearchBackgroundViewModel {
    let inputViewModel: SearchInputViewModel
    let instructionsViewModel: SearchInstructionsViewModel
}

extension SearchBackgroundViewModel {

    init(appCopyContent: AppCopyContent) {
        self.inputViewModel = SearchInputViewModel(searchParams: nil,
                                                   copyContent: appCopyContent.searchInput)
        self.instructionsViewModel = SearchInstructionsViewModel(copyContent: appCopyContent.searchInstructions)
    }

}
