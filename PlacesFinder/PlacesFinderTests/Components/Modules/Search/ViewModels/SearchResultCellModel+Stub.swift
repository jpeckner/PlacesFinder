//
//  SearchResultCellModel+Stub.swift
//  PlacesFinder
//
//  Created by Justin Peckner.
//  Copyright © 2020 Justin Peckner. All rights reserved.
//

#if DEBUG
@testable import PlacesFinder
#endif
import Shared
import SharedTestComponents

extension SearchResultCellModel {

    static func stubValue(name: NonEmptyString = .stubValue(),
                          ratingsAverage: SearchRatingValue = .three,
                          pricing: String? = nil,
                          image: URL = .stubValue()) -> SearchResultCellModel {
        return SearchResultCellModel(name: name,
                                     ratingsAverage: ratingsAverage,
                                     pricing: pricing,
                                     image: image)
    }

}
