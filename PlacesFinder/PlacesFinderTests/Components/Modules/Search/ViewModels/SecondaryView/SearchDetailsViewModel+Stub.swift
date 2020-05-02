// swiftlint:disable:this file_name
//
//  SearchDetailsViewModel+Stub.swift
//  PlacesFinderTests
//
//  Created by Justin Peckner.
//  Copyright © 2020 Justin Peckner. All rights reserved.
//

import Foundation
import Shared
import SharedTestComponents

extension SearchDetailsBasicInfoViewModel {

    static func stubValue(image: URL = .stubValue(),
                          name: NonEmptyString = .stubValue("stubName"),
                          address: NonEmptyString? = .stubValue("stubAddress"),
                          ratingsAverage: SearchRatingValue = .threeAndAHalf,
                          numRatingsMessage: String = "stubNumRatingsMessage",
                          pricing: String? = "stubPricing",
                          apiLinkCallback: OpenURLBlock? = nil) -> SearchDetailsBasicInfoViewModel {
        return SearchDetailsBasicInfoViewModel(image: image,
                                               name: name,
                                               address: address,
                                               ratingsAverage: ratingsAverage,
                                               numRatingsMessage: numRatingsMessage,
                                               pricing: pricing,
                                               apiLinkCallback: apiLinkCallback.map { IgnoredEquatable($0) })
    }

}

extension SearchDetailsMapCoordinateViewModel {

    static func stubValue(
        placeName: NonEmptyString = .stubValue("stubPlaceName"),
        address: NonEmptyString? = .stubValue("stubAddress"),
        coordinate: PlaceLookupCoordinate = .stubValue(),
        regionRadius: PlaceLookupDistance = .init(value: 123.0, unit: .meters)
    ) -> SearchDetailsMapCoordinateViewModel {
        return SearchDetailsMapCoordinateViewModel(placeName: placeName,
                                                   address: address,
                                                   coordinate: coordinate,
                                                   regionRadius: regionRadius)
    }

}
