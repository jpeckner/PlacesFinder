//
//  PlaceLookupParams.swift
//  PlacesFinder
//
//  Created by Justin Peckner.
//  Copyright © 2019 Justin Peckner. All rights reserved.
//

import Foundation
import Shared

typealias PlaceLookupDistance = Measurement<UnitLength>

typealias PlaceLookupCoordinate = LocationCoordinate

enum PlaceLookupSorting: String, CaseIterable, Codable {
    case bestMatch
    case distance
    case rating
    case reviewCount
}

struct PlaceLookupParams: Equatable {
    let keywords: NonEmptyString
    let coordinate: PlaceLookupCoordinate
    let radius: PlaceLookupDistance
    let sorting: PlaceLookupSorting
}
