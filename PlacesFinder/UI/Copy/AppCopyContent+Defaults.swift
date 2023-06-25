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
            placeholder: "Search nearby"
        )
        self.searchInstructions = SearchInstructionsCopyContent(
            iconImageName: "search_home",
            title: "Start Exploring!",
            description: "Enter search terms above to find nearby places.",
            resultsSource: "Powered by"
        )
        self.searchLocationDisabled = SearchLocationDisabledCopyContent(
            iconImageName: "location_disabled",
            title: "Where Am I?",
            description: "To show you the best nearby places, please enable location services in Settings.",
            ctaTitle: "Go to Settings"
        )
        self.searchNoInternet = SearchNoInternetCopyContent(
            iconImageName: "no_internet",
            title: "No internet",
            description: "Looks like you're not connected to the internet; please reconnect to search for great places!"
        )
        self.searchNoResults = SearchNoResultsCopyContent(
            iconImageName: "no_results",
            title: "No Results Found",
            description: "Try entering different search terms above...there's somewhere great nearby!"
        )
        self.searchResults = SearchResultsCopyContent(
            currencySymbol: "$",
            callNumberFormatString: "Call: %@",
            numRatingsSingularFormatString: "%d review",
            numRatingsPluralFormatString: "%d reviews"
        )
        self.searchRetry = SearchRetryCopyContent(
            iconImageName: "error",
            title: "Pardon the hiccup...",
            description: "Sorry, there was an error on our end.",
            ctaTitle: "Try again"
        )
        self.settingsHeaders = SettingsHeadersCopyContent(
            distanceSectionTitle: "SEARCH DISTANCE",
            sortSectionTitle: "SORT RESULTS BY"
        )
        self.settingsSortPreference = SettingsSortPreferenceCopyContent(
            bestMatchTitle: "Best match",
            distanceTitle: "Distance",
            ratingTitle: "Rating",
            reviewCountTitle: "Number of reviews"
        )
        self.settingsMeasurementSystem = SettingsMeasurementSystemCopyContent(
            imperial: "U.S",
            metric: "Metric"
        )
        self.settingsChildMenu = SettingsChildMenuCopyContent(
            sectionTitle: "CHILD PLACEHOLDER",
            ctaTitle: "Tap here for child test"
        )
        self.settingsChildView = SettingsChildViewCopyContent(
            iconImageName: "gear",
            titleFormat: "About %@",
            descriptionFormat: """
            Version %@

            Copyright (c) %d Justin Peckner. Distributed under the MIT License.
            """
        )
    }

}
