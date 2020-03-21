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
    let keywords: NonEmptyString?
    let isEditing: Bool
    let placeholder: String
}

extension SearchInputContentViewModel {

    init(keywords: NonEmptyString?,
         isEditing: Bool,
         copyContent: SearchInputCopyContent) {
        self.keywords = keywords
        self.isEditing = isEditing
        self.placeholder = copyContent.placeholder
    }

}

struct SearchInputViewModel {
    struct Callbacks {
        let isEditing: (SearchBarEditAction) -> Void
        let lookup: (SearchParams) -> Void
    }

    let content: SearchInputContentViewModel
    let callbacks: Callbacks
}
