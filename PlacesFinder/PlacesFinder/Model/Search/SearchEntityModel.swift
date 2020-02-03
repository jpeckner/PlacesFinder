//
//  SearchEntityModel.swift
//  PlacesFinder
//
//  Created by Justin Peckner.
//  Copyright © 2019 Justin Peckner. All rights reserved.
//

import Foundation
import Shared

struct SearchEntityModel: Equatable {
    let name: NonEmptyString
    let url: URL
    let ratings: SearchRatings
    let image: URL
    let addressLines: PlaceLookupAddressLines?
    let displayPhone: NonEmptyString?
    let dialablePhone: NonEmptyString?
    let pricing: PlaceLookupPricing?
    let coordinate: PlaceLookupCoordinate?
}
