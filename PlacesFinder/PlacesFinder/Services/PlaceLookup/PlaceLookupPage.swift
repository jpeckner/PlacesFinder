//
//  PlaceLookupPage.swift
//  Shared
//
//  Created by Justin Peckner.
//  Copyright © 2019 Justin Peckner. All rights reserved.
//

import Foundation
import Shared

public typealias PlaceLookupAddressLines = NonEmptyArray<NonEmptyString>

public struct PlaceLookupRatingFields: Hashable {
    public let averageRating: Percentage
    public let numRatings: Int

    public init(averageRating: Percentage,
                numRatings: Int) {
        self.averageRating = averageRating
        self.numRatings = numRatings
    }
}

public struct PlaceLookupPricing: Hashable {
    public let count: Int       // I.e. 2 if this business' pricing is "$$"
    public let maximum: Int     // I.e. 4 if the maximum pricing a business can have is "$$$$"

    public init(count: Int,
                maximum: Int) {
        self.count = count
        self.maximum = maximum
    }
}

// swiftlint:disable identifier_name
public struct PlaceLookupEntity: Hashable {
    public let id: NonEmptyString
    public let name: NonEmptyString
    public let addressLines: PlaceLookupAddressLines?
    public let displayPhone: NonEmptyString?
    public let dialablePhone: NonEmptyString?
    public let url: URL
    public let ratingFields: PlaceLookupRatingFields?
    public let pricing: PlaceLookupPricing?
    public let coordinate: PlaceLookupCoordinate?
    public let isPermanentlyClosed: Bool?
    public let image: URL?

    public init(id: NonEmptyString,
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

public struct PlaceLookupPage: Hashable {
    public let entities: [PlaceLookupEntity]

    public init(entities: [PlaceLookupEntity]) {
        self.entities = entities
    }
}
