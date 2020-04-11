//
//  SearchInputCopyContent+Stub.swift
//  PlacesFinder
//
//  Created by Justin Peckner.
//  Copyright © 2020 Justin Peckner. All rights reserved.
//

#if DEBUG
@testable import PlacesFinder
#endif

extension SearchInputCopyContent {

    static func stubValue(placeholder: String = "stubPlaceholder") -> SearchInputCopyContent {
        return SearchInputCopyContent(placeholder: placeholder)
    }

}
