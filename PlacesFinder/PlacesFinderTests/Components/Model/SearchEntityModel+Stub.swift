//
//  SearchEntityModel+Stub.swift
//  PlacesFinderTests
//
//  Created by Justin Peckner.
//  Copyright © 2019 Justin Peckner. All rights reserved.
//

import Foundation
#if DEBUG
@testable import PlacesFinder
#endif
import Shared
import SharedTestComponents

extension SearchRatings {

    static func stubValue(average: SearchRatingValue = .one,
                          numRatings: Int = 123) -> SearchRatings {
        return SearchRatings(average: average,
                             numRatings: numRatings)
    }

}

extension SearchSummaryModel {

    static func stubValue(name: NonEmptyString = NonEmptyString.stubValue("Entity Name"),
                          ratings: SearchRatings = .stubValue(),
                          pricing: PlaceLookupPricing? = .stubValue(),
                          image: URL = .stubValue()) -> SearchSummaryModel {
        return SearchSummaryModel(name: name,
                                  ratings: ratings,
                                  pricing: pricing,
                                  image: image)
    }

}

extension SearchDetailsModel {

    static func stubValue(name: NonEmptyString = .stubValue("stubDetailsModelName"),
                          addressLines: PlaceLookupAddressLines = .stubValue(),
                          displayPhone: NonEmptyString? = .stubValue("stubDisplayPhone"),
                          dialablePhone: NonEmptyString? = .stubValue("stubDialablePhone"),
                          url: URL = .stubValue(),
                          ratings: SearchRatings = .stubValue(),
                          pricing: PlaceLookupPricing? = .stubValue(),
                          coordinate: PlaceLookupCoordinate? = .stubValue(),
                          image: URL = .stubValue()) -> SearchDetailsModel {
        return SearchDetailsModel(name: name,
                                  addressLines: addressLines,
                                  displayPhone: displayPhone,
                                  dialablePhone: dialablePhone,
                                  url: url,
                                  ratings: ratings,
                                  pricing: pricing,
                                  coordinate: coordinate,
                                  image: image)
    }

}

extension SearchEntityModel {

    static func stubValue(summaryModel: SearchSummaryModel = .stubValue(),
                          detailsModel: SearchDetailsModel = .stubValue()) -> SearchEntityModel {
        return SearchEntityModel(summaryModel: summaryModel,
                                 detailsModel: detailsModel)
    }

    static func stubValue(named name: String) -> SearchEntityModel {
        return SearchEntityModel.stubValue(summaryModel: .stubValue(name: .stubValue(name)))
    }

}
