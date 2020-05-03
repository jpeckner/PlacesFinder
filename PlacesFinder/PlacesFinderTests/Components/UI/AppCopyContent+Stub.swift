//
//  AppCopyContent+Stub.swift
//  PlacesFinderTests
//
//  Created by Justin Peckner.
//  Copyright © 2020 Justin Peckner. All rights reserved.
//

import Foundation
import Shared

extension AppCopyContent {

    static func stubValue(displayName: NonEmptyString = .stubValue("stubDisplayName")) -> AppCopyContent {
        return AppCopyContent(displayName: displayName)
    }

}

extension DisplayNameCopyContent {

    static func stubValue(name: NonEmptyString = .stubValue("stubDisplayName")) -> DisplayNameCopyContent {
        return DisplayNameCopyContent(name: name)
    }

}

extension SearchNoResultsCopyContent {

    static func stubValue() -> SearchNoResultsCopyContent {
        return SearchNoResultsCopyContent(
            iconImageName: "stubIconImageName",
            title: "stubTitle",
            description: "stubDescription"
        )
    }

}

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

extension SearchRetryCopyContent {

    static func stubValue() -> SearchRetryCopyContent {
        return SearchRetryCopyContent(
            iconImageName: "stubIconImageName",
            title: "stubTitle",
            description: "stubDescription",
            ctaTitle: "stubCTATitle"
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
