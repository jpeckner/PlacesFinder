//
//  SearchInputContentViewModel.swift
//  PlacesFinder
//
//  Created by Justin Peckner.
//  Copyright © 2020 Justin Peckner. All rights reserved.
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
