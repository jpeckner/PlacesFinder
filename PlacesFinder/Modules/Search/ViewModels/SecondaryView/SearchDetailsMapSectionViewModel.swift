//
//  SearchDetailsMapSectionViewModel.swift
//  PlacesFinder
//
//  Created by Justin Peckner.
//  Copyright © 2019 Justin Peckner. All rights reserved.
//

import Foundation
import Shared

struct SearchDetailsMapCoordinateViewModel: Equatable {
    let placeName: NonEmptyString
    let address: NonEmptyString?
    let coordinate: PlaceLookupCoordinate
    let regionRadius: PlaceLookupDistance
}

enum SearchDetailsMapSectionViewModel: Equatable {
    // sourcery: cellType = "SearchDetailsMapCell"
    case mapCoordinate(SearchDetailsMapCoordinateViewModel)
}
