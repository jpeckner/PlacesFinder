//
//  AppCopyContent.swift
//  PlacesFinder
//
//  Created by Justin Peckner.
//  Copyright © 2019 Justin Peckner. All rights reserved.
//

import Shared

struct AppCopyContent: Equatable {
    let displayName: DisplayNameCopyContent
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

struct DisplayNameCopyContent: Equatable {
    let name: NonEmptyString
}

struct SearchInputCopyContent: Equatable {
    let placeholder: String
}

struct SearchInstructionsCopyContent: Equatable {
    let iconImageName: String
    let title: String
    let description: String
    let resultsSource: String
}

struct SearchLocationDisabledCopyContent: Equatable {
    let iconImageName: String
    let title: String
    let description: String
    let ctaTitle: String
}

struct SearchNoInternetCopyContent: Equatable {
    let iconImageName: String
    let title: String
    let description: String
}

struct SearchNoResultsCopyContent: Equatable {
    let iconImageName: String
    let title: String
    let description: String
}

struct SearchResultsCopyContent: Equatable {
    let currencySymbol: String
    let callNumberFormatString: String
    let numRatingsSingularFormatString: String
    let numRatingsPluralFormatString: String
}

struct SearchRetryCopyContent: Equatable {
    let iconImageName: String
    let title: String
    let description: String
    let ctaTitle: String
}

struct SettingsHeadersCopyContent: Equatable {
    let distanceSectionTitle: String
    let sortSectionTitle: String
}

struct SettingsSortPreferenceCopyContent: Equatable {
    let bestMatchTitle: String
    let distanceTitle: String
    let ratingTitle: String
    let reviewCountTitle: String
}

struct SettingsMeasurementSystemCopyContent: Equatable {
    let imperial: String
    let metric: String
}
