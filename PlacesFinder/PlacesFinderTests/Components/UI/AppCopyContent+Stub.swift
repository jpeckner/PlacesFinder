// swiftlint:disable:this file_name
//
//  SearchResultsCopyContent+Stub.swift
//  PlacesFinder
//
//  Created by Justin Peckner.
//  Copyright © 2020 Justin Peckner. All rights reserved.
//

import Foundation
#if DEBUG
@testable import PlacesFinder
#endif

extension SearchResultsCopyContent {

    static func stubValue() -> SearchResultsCopyContent {
        return SearchResultsCopyContent(
            currencySymbol: "+",
            callNumberFormatString: "callNumberFormatString - %@",
            numRatingsSingularFormatString: "numRatingsSingularFormatString - %d",
            numRatingsPluralFormatString: "numRatingsPluralFormatString - %d"
        )
    }

}

extension SettingsMeasurementSystemCopyContent {

    static func stubValue() -> SettingsMeasurementSystemCopyContent {
        return SettingsMeasurementSystemCopyContent(imperial: "stubImperialTitle",
                                                    metric: "stubMetricTitle")
    }

}

extension SettingsSortPreferenceCopyContent {

    static func stubValue() -> SettingsSortPreferenceCopyContent {
        return SettingsSortPreferenceCopyContent(bestMatchTitle: "stubBestMatchTitle",
                                                 distanceTitle: "stubDistanceTitle",
                                                 ratingTitle: "stubRatingTitle",
                                                 reviewCountTitle: "stubReviewCountTitle")
    }

}
