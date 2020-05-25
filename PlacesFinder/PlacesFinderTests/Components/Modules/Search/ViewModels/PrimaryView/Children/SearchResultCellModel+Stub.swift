//
//  SearchResultCellModel+Stub.swift
//  PlacesFinderTests
//
//  Created by Justin Peckner.
//  Copyright © 2020 Justin Peckner. All rights reserved.
//

import Shared
import SharedTestComponents

extension SearchResultCellModel {

    static func stubValue(
        name: NonEmptyString = .stubValue(),
        ratingsAverage: SearchRatingValue = .three,
        pricing: String? = nil,
        image: DownloadedImageViewModel = DownloadedImageViewModel(url: .stubValue())
    ) -> SearchResultCellModel {
        return SearchResultCellModel(name: name,
                                     ratingsAverage: ratingsAverage,
                                     pricing: pricing,
                                     image: image)
    }

}
