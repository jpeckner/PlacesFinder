//
//  SearchEntityModel.swift
//  PlacesFinder
//
//  Created by Justin Peckner.
//  Copyright © 2019 Justin Peckner. All rights reserved.
//

import Foundation
import Shared

// swiftlint:disable identifier_name
struct SearchEntityModel: Equatable {
    let id: NonEmptyString
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
