//
//  SearchResultCellModel.swift
//  PlacesFinder
//
//  Created by Justin Peckner.
//  Copyright © 2019 Justin Peckner. All rights reserved.
//

import Foundation
import Shared

struct SearchResultCellModel {
    let name: NonEmptyString
    let ratingsAverage: SearchRatingValue
    let pricing: String?
    let image: URL
}

extension SearchResultCellModel {

    init(model: SearchEntityModel,
         copyFormatter: SearchCopyFormatterProtocol,
         resultsCopyContent: SearchResultsCopyContent) {
        self.name = model.name
        self.ratingsAverage = model.ratings.average
        self.pricing = model.pricing.map { copyFormatter.formatPricing(resultsCopyContent, pricing: $0) }
        self.image = model.image
    }

}
