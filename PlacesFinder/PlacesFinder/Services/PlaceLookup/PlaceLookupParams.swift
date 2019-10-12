//
//  PlaceLookupParams.swift
//  Shared
//
//  Created by Justin Peckner.
//  Copyright © 2019 Justin Peckner. All rights reserved.
//

import Foundation
import Shared

public typealias PlaceLookupDistance = Measurement<UnitLength>

public typealias PlaceLookupCoordinate = LocationCoordinate

public enum PlaceLookupSorting: String, CaseIterable, Codable {
    case bestMatch
    case distance
    case rating
    case reviewCount
}

public struct PlaceLookupParams: Equatable {

    public let keywords: NonEmptyString
    public let coordinate: PlaceLookupCoordinate
    public let radius: PlaceLookupDistance
    public let sorting: PlaceLookupSorting

    public init(keywords: NonEmptyString,
                coordinate: PlaceLookupCoordinate,
                radius: PlaceLookupDistance,
                sorting: PlaceLookupSorting) {
        self.keywords = keywords
        self.coordinate = coordinate
        self.radius = radius
        self.sorting = sorting
    }

}
