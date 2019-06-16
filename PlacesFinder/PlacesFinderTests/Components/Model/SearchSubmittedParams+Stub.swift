//
//  SearchSubmittedParams+Stub.swift
//  PlacesFinderTests
//
//  Created by Justin Peckner.
//  Copyright © 2019 Justin Peckner. All rights reserved.
//

#if DEBUG
@testable import PlacesFinder
#endif
import Shared
import SharedTestComponents

extension SearchSubmittedParams {

    static func stubValue(keywords: NonEmptyString = .stubValue("stubkeywords")) -> SearchSubmittedParams {
        return SearchSubmittedParams(keywords: keywords)
    }

}
