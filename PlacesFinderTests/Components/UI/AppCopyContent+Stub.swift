//
//  AppCopyContent+Stub.swift
//  PlacesFinderTests
//
//  Copyright (c) 2020 Justin Peckner
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