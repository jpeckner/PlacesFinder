//
//  SearchInputContentViewModel+Stub.swift
//  PlacesFinder
//
//  Created by Justin Peckner.
//  Copyright © 2020 Justin Peckner. All rights reserved.
//

import Shared

extension SearchInputContentViewModel {

    static func stubValue(keywords: NonEmptyString? = nil,
                          isEditing: Bool = false,
                          placeholder: String = "stubPlaceholder") -> SearchInputContentViewModel {
        return SearchInputContentViewModel(keywords: keywords,
                                           isEditing: isEditing,
                                           placeholder: placeholder)
    }

}
