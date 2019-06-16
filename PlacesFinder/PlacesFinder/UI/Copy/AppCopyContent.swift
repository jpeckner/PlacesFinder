//
//  AppCopyContent.swift
//  PlacesFinder
//
//  Created by Justin Peckner.
//  Copyright © 2019 Justin Peckner. All rights reserved.
//

import Shared

struct AppCopyContent {
    let displayName: NonEmptyString
    let searchInput: SearchInputCopyContent
    let searchInstructions: SearchInstructionsCopyContent
    let searchLocationDisabled: SearchLocationDisabledCopyContent
    let searchNoInternet: SearchNoInternetCopyContent
    let searchNoResults: SearchNoResultsCopyContent
    let searchResults: SearchResultsCopyContent
    let searchRetry: SearchRetryCopyContent
    let settingsHeaders: SettingsHeadersCopyContent
    let settingsSortPreference: SettingsSortPreferenceCopyContent
    let settingsMeasurementSystem: SettingsMeasurementSystemCopyContent
}

struct SearchInputCopyContent {
    let placeholder: String
    let cancelButtonTitle: String
}

struct SearchInstructionsCopyContent {
    let iconImage: UIImage
    let title: String
    let description: String
    let resultsSource: String
}

struct SearchLocationDisabledCopyContent {
    let iconImage: UIImage
    let title: String
    let description: String
    let ctaTitle: String
}

struct SearchNoInternetCopyContent {
    let iconImage: UIImage
    let title: String
    let description: String
}

struct SearchNoResultsCopyContent {
    let iconImage: UIImage
    let title: String
    let description: String
}

struct SearchResultsCopyContent {
    let currencySymbol: String
    let callNumberFormatString: String
    let numRatingsSingularFormatString: String
    let numRatingsPluralFormatString: String
}

struct SearchRetryCopyContent {
    let iconImage: UIImage
    let title: String
    let description: String
    let ctaTitle: String
}

struct SettingsHeadersCopyContent {
    let distanceSectionTitle: String
    let sortSectionTitle: String
}

struct SettingsSortPreferenceCopyContent {
    let bestMatchTitle: String
    let distanceTitle: String
    let ratingTitle: String
    let reviewCountTitle: String
}

struct SettingsMeasurementSystemCopyContent {
    let imperial: String
    let metric: String
    let delimeter: String
}
