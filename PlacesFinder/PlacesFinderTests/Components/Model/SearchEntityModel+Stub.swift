//
//  SearchEntityModel+Stub.swift
//  PlacesFinderTests
//
//  Created by Justin Peckner.
//  Copyright © 2019 Justin Peckner. All rights reserved.
//

import Foundation
#if DEBUG
@testable import PlacesFinder
#endif
import Shared
import SharedTestComponents

extension SearchRatings {

    static func stubValue(average: SearchRatingValue = .one,
                          numRatings: Int = 123) -> SearchRatings {
        return SearchRatings(average: average,
                             numRatings: numRatings)
    }

}

extension SearchEntityModel {

    // swiftlint:disable identifier_name
    static func stubValue(id: String = "stubID",
                          name: String = "stubName",
                          url: URL = .stubValue(),
                          ratings: SearchRatings = .stubValue(),
                          image: URL = .stubValue(),
                          addressLines: PlaceLookupAddressLines = .stubValue(),
                          displayPhone: String? = "stubDisplayPhone",
                          dialablePhone: String? = "stubDialablePhone",
                          pricing: PlaceLookupPricing? = .stubValue(),
                          coordinate: PlaceLookupCoordinate? = .stubValue()) -> SearchEntityModel {
        return SearchEntityModel(id: NonEmptyString.stubValue(id),
                                 name: NonEmptyString.stubValue(name),
                                 url: url,
                                 ratings: ratings,
                                 image: image,
                                 addressLines: addressLines,
                                 displayPhone: displayPhone.map { NonEmptyString.stubValue($0) },
                                 dialablePhone: dialablePhone.map { NonEmptyString.stubValue($0) },
                                 pricing: pricing,
                                 coordinate: coordinate)
    }
    // swiftlint:enable identifier_name

}
