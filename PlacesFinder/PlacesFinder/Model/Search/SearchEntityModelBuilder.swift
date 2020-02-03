//
//  SearchEntityModelBuilder.swift
//  PlacesFinder
//
//  Created by Justin Peckner.
//  Copyright © 2019 Justin Peckner. All rights reserved.
//

import Shared

protocol SearchEntityModelBuilderProtocol: AutoMockable {
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
