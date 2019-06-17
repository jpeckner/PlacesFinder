//
//  SearchEntityModel.swift
//  PlacesFinder
//
//  Created by Justin Peckner.
//  Copyright © 2019 Justin Peckner. All rights reserved.
//

import Foundation
import Shared

struct SearchSummaryModel: Equatable {
    let name: NonEmptyString
    let ratings: SearchRatings
    let pricing: PlaceLookupPricing?
    let image: URL
}

struct SearchDetailsModel: Equatable {
    let name: NonEmptyString
    let addressLines: PlaceLookupAddressLines?
    let displayPhone: NonEmptyString?
    let dialablePhone: NonEmptyString?
    let url: URL
    let ratings: SearchRatings
    let pricing: PlaceLookupPricing?
    let coordinate: PlaceLookupCoordinate?
    let image: URL
}

struct SearchEntityModel: Equatable {
    let summaryModel: SearchSummaryModel
    let detailsModel: SearchDetailsModel
}
