//
//  PlaceLookupPage.swift
//  PlacesFinder
//
//  Created by Justin Peckner.
//  Copyright © 2019 Justin Peckner. All rights reserved.
//

import Foundation
import Shared

typealias PlaceLookupAddressLines = NonEmptyArray<NonEmptyString>

struct PlaceLookupRatingFields: Hashable {
    let averageRating: Percentage
    let numRatings: Int
}

struct PlaceLookupPricing: Hashable {
    let count: Int       // I.e. 2 if this business' pricing is "$$"
    let maximum: Int     // I.e. 4 if the maximum pricing a business can have is "$$$$"
}

// swiftlint:disable identifier_name
struct PlaceLookupEntity: Hashable {
    let id: NonEmptyString
    let name: NonEmptyString
    let addressLines: PlaceLookupAddressLines?
    let displayPhone: NonEmptyString?
    let dialablePhone: NonEmptyString?
    let url: URL
    let ratingFields: PlaceLookupRatingFields?
    let pricing: PlaceLookupPricing?
    let coordinate: PlaceLookupCoordinate?
    let isPermanentlyClosed: Bool?
    let image: URL?
}
// swiftlint:enable identifier_name

struct PlaceLookupPage: Hashable {
    let entities: [PlaceLookupEntity]
}
