//
//  SearchBackgroundViewModel.swift
//  PlacesFinder
//
//  Created by Justin Peckner.
//  Copyright © 2020 Justin Peckner. All rights reserved.
//

import Foundation

struct SearchBackgroundViewModel {
    let contentViewModel: SearchInputContentViewModel
    let instructionsViewModel: SearchInstructionsViewModel
}

extension SearchBackgroundViewModel {

    init(appCopyContent: AppCopyContent) {
        let inputParams = SearchInputParams(params: nil)
        self.contentViewModel = SearchInputContentViewModel(inputParams: inputParams,
                                                            copyContent: appCopyContent.searchInput)

        self.instructionsViewModel = SearchInstructionsViewModel(copyContent: appCopyContent.searchInstructions)
    }

}
