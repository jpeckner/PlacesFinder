//
//  AppCopyContent+Defaults.swift
//  PlacesFinder
//
//  Created by Justin Peckner.
//  Copyright © 2019 Justin Peckner. All rights reserved.
//

import Shared

extension AppCopyContent {

    // swiftlint:disable function_body_length
    init(displayName: NonEmptyString) {
        self.displayName = DisplayNameCopyContent(name: displayName)

        self.searchInput = SearchInputCopyContent(
            placeholder: "Search nearby",
            cancelButtonTitle: "Cancel"
        )
        self.searchInstructions = SearchInstructionsCopyContent(
            iconImage: #imageLiteral(resourceName: "search_home"),
            title: "Start Exploring!",
            description: "Enter search terms above to find nearby places.",
            resultsSource: "Powered by"
        )
        self.searchLocationDisabled = SearchLocationDisabledCopyContent(
            iconImage: #imageLiteral(resourceName: "location_disabled"),
            title: "Where Am I?",
            description: "To show you the best nearby places, please enable location services in Settings.",
            ctaTitle: "Go to Settings"
        )
        self.searchNoInternet = SearchNoInternetCopyContent(
            iconImage: #imageLiteral(resourceName: "no_internet"),
            title: "No internet",
            description: "Looks like you're not connected to the internet; please reconnect to search for great places!"
        )
        self.searchNoResults = SearchNoResultsCopyContent(
            iconImage: #imageLiteral(resourceName: "no_results"),
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
            iconImage: #imageLiteral(resourceName: "error"),
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
    }

}
