//
//  SearchResultCellModel.swift
//  PlacesFinder
//
//  Copyright (c) 2019 Justin Peckner
//  
//  Permission is hereby granted, free of charge, to any person obtaining a copy
//  of this software and associated documentation files (the "Software"), to deal
//  in the Software without restriction, including without limitation the rights
//  to use, copy, modify, merge, publish, distribute, sublicense, and/or sell
//  copies of the Software, and to permit persons to whom the Software is
//  furnished to do so, subject to the following conditions:
//  
//  The above copyright notice and this permission notice shall be included in all
//  copies or substantial portions of the Software.
//  
//  THE SOFTWARE IS PROVIDED "AS IS", WITHOUT WARRANTY OF ANY KIND, EXPRESS OR
//  IMPLIED, INCLUDING BUT NOT LIMITED TO THE WARRANTIES OF MERCHANTABILITY,
//  FITNESS FOR A PARTICULAR PURPOSE AND NONINFRINGEMENT. IN NO EVENT SHALL THE
//  AUTHORS OR COPYRIGHT HOLDERS BE LIABLE FOR ANY CLAIM, DAMAGES OR OTHER
//  LIABILITY, WHETHER IN AN ACTION OF CONTRACT, TORT OR OTHERWISE, ARISING FROM,
//  OUT OF OR IN CONNECTION WITH THE SOFTWARE OR THE USE OR OTHER DEALINGS IN THE
//  SOFTWARE.

import Foundation
import Shared

struct SearchResultCellModel: Identifiable, Equatable {
    let id: NonEmptyString
    let name: NonEmptyString
    let ratingsAverage: SearchRatingValue
    let pricing: String?
    let image: DownloadedImageViewModel
    let colorings: SearchResultsViewColorings
}

// MARK: SearchResultCellModelBuilder

// sourcery: AutoMockable
protocol SearchResultCellModelBuilderProtocol {
    func buildViewModel(model: SearchEntityModel,
                        resultsCopyContent: SearchResultsCopyContent,
                        colorings: SearchResultsViewColorings) -> SearchResultCellModel
}

class SearchResultCellModelBuilder: SearchResultCellModelBuilderProtocol {

    let copyFormatter: SearchCopyFormatterProtocol

    init(copyFormatter: SearchCopyFormatterProtocol) {
        self.copyFormatter = copyFormatter
    }

    func buildViewModel(model: SearchEntityModel,
                        resultsCopyContent: SearchResultsCopyContent,
                        colorings: SearchResultsViewColorings) -> SearchResultCellModel {
        SearchResultCellModel(
            id: model.id,
            name: model.name,
            ratingsAverage: model.ratings.average,
            pricing: model.pricing.map { copyFormatter.formatPricing(resultsCopyContent, pricing: $0) },
            image: DownloadedImageViewModel(url: model.image),
            colorings: colorings
        )
    }

}
