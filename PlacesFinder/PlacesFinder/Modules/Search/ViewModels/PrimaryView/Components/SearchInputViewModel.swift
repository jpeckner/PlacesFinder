//
//  SearchInputViewModel.swift
//  PlacesFinder
//
//  Created by Justin Peckner.
//  Copyright © 2019 Justin Peckner. All rights reserved.
//

import Foundation
import Shared

struct SearchInputViewModel {
    let inputKeywords: NonEmptyString?
    let placeholder: String
    let cancelButtonTitle: String
}

extension SearchInputViewModel {

    init(inputKeywords: NonEmptyString?,
         copyContent: SearchInputCopyContent) {
        self.inputKeywords = inputKeywords
        self.placeholder = copyContent.placeholder
        self.cancelButtonTitle = copyContent.cancelButtonTitle
    }

}
