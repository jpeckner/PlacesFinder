//
//  SearchResultCellModel.swift
//  PlacesFinder
//
//  Created by Justin Peckner.
//  Copyright © 2019 Justin Peckner. All rights reserved.
//

import Foundation
import Shared

struct SearchResultCellModel: Equatable {
    let name: NonEmptyString
    let ratingsAverage: SearchRatingValue
    let pricing: String?
    let image: DownloadedImageViewModel
}

// MARK: SearchResultCellModelBuilder

protocol SearchResultCellModelBuilderProtocol: AutoMockable {
    func buildViewModel(_ model: SearchEntityModel,
                        resultsCopyContent: SearchResultsCopyContent) -> SearchResultCellModel
}

class SearchResultCellModelBuilder: SearchResultCellModelBuilderProtocol {

    let copyFormatter: SearchCopyFormatterProtocol

    init(copyFormatter: SearchCopyFormatterProtocol) {
        self.copyFormatter = copyFormatter
    }

    func buildViewModel(_ model: SearchEntityModel,
                        resultsCopyContent: SearchResultsCopyContent) -> SearchResultCellModel {
        return SearchResultCellModel(
            name: model.name,
            ratingsAverage: model.ratings.average,
            pricing: model.pricing.map { copyFormatter.formatPricing(resultsCopyContent, pricing: $0) },
            image: DownloadedImageViewModel(url: model.image)
        )
    }

}
