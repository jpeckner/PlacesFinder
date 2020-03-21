//
//  SearchInputViewModel.swift
//  PlacesFinder
//
//  Created by Justin Peckner.
//  Copyright © 2019 Justin Peckner. All rights reserved.
//

import Foundation
import Shared

struct SearchInputContentViewModel: Equatable {
    let inputParams: SearchInputParams
    let placeholder: String
}

extension SearchInputContentViewModel {

    init(inputParams: SearchInputParams,
         copyContent: SearchInputCopyContent) {
        self.inputParams = inputParams
        self.placeholder = copyContent.placeholder
    }

}

struct SearchInputViewModel {
    struct Callbacks {
        let lookup: (SearchParams) -> Void
    }

    let content: SearchInputContentViewModel
    let callbacks: Callbacks
}
