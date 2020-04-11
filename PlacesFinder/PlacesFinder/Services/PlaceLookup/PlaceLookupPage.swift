//
//  PlaceLookupPage.swift
//  Shared
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

    init(averageRating: Percentage,
                numRatings: Int) {
        self.averageRating = averageRating
        self.numRatings = numRatings
    }
}

struct PlaceLookupPricing: Hashable {
    let count: Int       // I.e. 2 if this business' pricing is "$$"
    let maximum: Int     // I.e. 4 if the maximum pricing a business can have is "$$$$"

    init(count: Int,
                maximum: Int) {
        self.count = count
        self.maximum = maximum
    }
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

    init(id: NonEmptyString,
                name: NonEmptyString,
                addressLines: PlaceLookupAddressLines?,
                displayPhone: NonEmptyString?,
                dialablePhone: NonEmptyString?,
                url: URL,
                ratingFields: PlaceLookupRatingFields?,
                pricing: PlaceLookupPricing?,
                coordinate: PlaceLookupCoordinate?,
                isPermanentlyClosed: Bool?,
                image: URL?) {
        self.id = id
        self.name = name
        self.addressLines = addressLines
        self.displayPhone = displayPhone
        self.dialablePhone = dialablePhone
        self.url = url
        self.ratingFields = ratingFields
        self.pricing = pricing
        self.coordinate = coordinate
        self.isPermanentlyClosed = isPermanentlyClosed
        self.image = image
    }
}
// swiftlint:enable identifier_name

struct PlaceLookupPage: Hashable {
    let entities: [PlaceLookupEntity]

    init(entities: [PlaceLookupEntity]) {
        self.entities = entities
    }
}
