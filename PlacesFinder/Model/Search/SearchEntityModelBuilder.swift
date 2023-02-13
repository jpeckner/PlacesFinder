//
//  SearchEntityModelBuilder.swift
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

import Shared

// sourcery: AutoMockable
protocol SearchEntityModelBuilderProtocol {
    func buildEntityModels(_ entities: [PlaceLookupEntity]) -> [SearchEntityModel]

    func buildEntityModel(_ entity: PlaceLookupEntity) -> SearchEntityModel?
}

extension SearchEntityModelBuilderProtocol {

    func buildEntityModels(_ entities: [PlaceLookupEntity]) -> [SearchEntityModel] {
        return entities.compactMap { buildEntityModel($0) }
    }

}

// MARK: SearchEntityModelBuilder

class SearchEntityModelBuilder: SearchEntityModelBuilderProtocol {

    func buildEntityModel(_ entity: PlaceLookupEntity) -> SearchEntityModel? {
        guard let isPermanentlyClosed = entity.isPermanentlyClosed,
            !isPermanentlyClosed
        else { return nil }

        return SearchEntityModel(entity: entity)
    }

}

private extension SearchEntityModel {

    init?(entity: PlaceLookupEntity) {
        guard let ratings = entity.ratingFields?.searchRatings,
            let image = entity.image
        else { return nil }

        self.name = entity.name
        self.url = entity.url
        self.ratings = ratings
        self.image = image
        self.addressLines = entity.addressLines
        self.displayPhone = entity.displayPhone
        self.dialablePhone = entity.dialablePhone
        self.pricing = entity.pricing
        self.coordinate = entity.coordinate
    }

}

private extension PlaceLookupRatingFields {

    var searchRatings: SearchRatings? {
        guard let average = SearchRatingValue(averageRating: averageRating) else { return nil }

        return SearchRatings(average: average,
                             numRatings: numRatings)
    }

}
