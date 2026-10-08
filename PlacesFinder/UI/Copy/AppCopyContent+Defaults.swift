//
//  AppCopyContent+Defaults.swift
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

extension AppCopyContent {

    init(displayName: NonEmptyString) {
        self.displayName = DisplayNameCopyContent(name: displayName)

        self.searchInput = SearchInputCopyContent(
            placeholder: L10n.SearchInput.placeholder
        )
        self.searchInstructions = SearchInstructionsCopyContent(
            iconImageName: "search_home",
            title: L10n.SearchInstructions.title,
            description: L10n.SearchInstructions.description,
            resultsSource: L10n.SearchInstructions.resultsSource
        )
        self.searchLocationDisabled = SearchLocationDisabledCopyContent(
            iconImageName: "location_disabled",
            title: L10n.SearchLocationDisabled.title,
            description: L10n.SearchLocationDisabled.description,
            ctaTitle: L10n.SearchLocationDisabled.ctaTitle
        )
        self.searchNoInternet = SearchNoInternetCopyContent(
            iconImageName: "no_internet",
            title: L10n.SearchNoInternet.title,
            description: L10n.SearchNoInternet.description
        )
        self.searchNoResults = SearchNoResultsCopyContent(
            iconImageName: "no_results",
            title: L10n.SearchNoResults.title,
            description: L10n.SearchNoResults.description
        )
        self.searchResults = SearchResultsCopyContent(
            currencySymbol: L10n.SearchResults.currencySymbol
        )
        self.searchRetry = SearchRetryCopyContent(
            iconImageName: "error",
            title: L10n.SearchRetry.title,
            description: L10n.SearchRetry.description,
            ctaTitle: L10n.SearchRetry.ctaTitle
        )
        self.settingsHeaders = SettingsHeadersCopyContent(
            distanceSectionTitle: L10n.SettingsHeaders.distanceSectionTitle,
            sortSectionTitle: L10n.SettingsHeaders.sortSectionTitle
        )
        self.settingsSortPreference = SettingsSortPreferenceCopyContent(
            bestMatchTitle: L10n.SettingsSortPreference.bestMatchTitle,
            distanceTitle: L10n.SettingsSortPreference.distanceTitle,
            ratingTitle: L10n.SettingsSortPreference.ratingTitle,
            reviewCountTitle: L10n.SettingsSortPreference.reviewCountTitle
        )
        self.settingsMeasurementSystem = SettingsMeasurementSystemCopyContent(
            imperial: L10n.SettingsMeasurementSystem.imperial,
            metric: L10n.SettingsMeasurementSystem.metric
        )
        self.aboutAppView = AboutAppViewCopyContent(
            iconImageName: "app_icon"
        )
    }

}
