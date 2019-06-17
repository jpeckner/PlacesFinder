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
            !isPermanentlyClosed,
            let summaryModel = SearchSummaryModel(entity: entity)
        else { return nil }

        let detailsModel = SearchDetailsModel(summaryModel: summaryModel,
                                              entity: entity)
        return SearchEntityModel(
            summaryModel: summaryModel,
            detailsModel: detailsModel
        )
    }

}

private extension SearchSummaryModel {

    init?(entity: PlaceLookupEntity) {
        guard let ratings = entity.ratingFields?.searchRatings,
            let image = entity.image
        else { return nil }

        self.name = entity.name
        self.ratings = ratings
        self.pricing = entity.pricing
        self.image = image
    }

}

private extension SearchDetailsModel {

    init(summaryModel: SearchSummaryModel,
         entity: PlaceLookupEntity) {
        self.name = summaryModel.name
        self.addressLines = entity.addressLines
        self.displayPhone = entity.displayPhone
        self.dialablePhone = entity.dialablePhone
        self.url = entity.url
        self.ratings = summaryModel.ratings
        self.pricing = summaryModel.pricing
        self.coordinate = entity.coordinate
        self.image = summaryModel.image
    }

}

private extension PlaceLookupRatingFields {

    var searchRatings: SearchRatings? {
        guard let average = SearchRatingValue(averageRating: averageRating) else { return nil }

        return SearchRatings(average: average,
                             numRatings: numRatings)
    }

}
