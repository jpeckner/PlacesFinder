//
//  AppCopyContent.swift
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
