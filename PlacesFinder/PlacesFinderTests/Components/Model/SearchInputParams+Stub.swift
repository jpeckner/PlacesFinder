//
//  SearchInputParams+Stub.swift
//  PlacesFinderTests
//
//  Created by Justin Peckner.
//  Copyright © 2019 Justin Peckner. All rights reserved.
//

import Shared
import SharedTestComponents

extension SearchParams {

    static func stubValue(keywords: NonEmptyString = .stubValue("stubkeywords")) -> SearchParams {
        return SearchParams(keywords: keywords)
    }

}

extension SearchInputParams {

    static func stubValue(params: SearchParams? = .stubValue(),
                          isEditing: Bool = false) -> SearchInputParams {
        return SearchInputParams(params: params,
                                 isEditing: isEditing)
    }

}
