// swiftlint:disable all
// Generated using SwiftGen — https://github.com/SwiftGen/SwiftGen

import Foundation

// swiftlint:disable superfluous_disable_command file_length implicit_return prefer_self_in_static_references

// MARK: - Strings

// swiftlint:disable explicit_type_interface function_parameter_count identifier_name line_length
// swiftlint:disable nesting type_body_length type_name vertical_whitespace_opening_braces
internal enum L10n {
  internal enum AboutAppDetails {
    /// Version %@
    /// 
    /// Copyright (c) %@ Justin Peckner. Distributed under the MIT License.
    internal static func description(_ p1: String, _ p2: String) -> String {
      return L10n.tr("Localizable", "about_app_details.description", p1, p2, fallback: "Version %@\n\nCopyright (c) %@ Justin Peckner. Distributed under the MIT License.")
    }
    /// %@
    internal static func title(_ p1: String) -> String {
      return L10n.tr("Localizable", "about_app_details.title", p1, fallback: "%@")
    }
  }
  internal enum AboutAppMenu {
    /// About %@
    internal static func ctaTitle(_ p1: String) -> String {
      return L10n.tr("Localizable", "about_app_menu.cta_title", p1, fallback: "About %@")
    }
  }
  internal enum SearchInput {
    /// Search nearby
    internal static let placeholder = L10n.tr("Localizable", "search_input.placeholder", fallback: "Search nearby")
  }
  internal enum SearchInstructions {
    /// Enter search terms above to find nearby places.
    internal static let description = L10n.tr("Localizable", "search_instructions.description", fallback: "Enter search terms above to find nearby places.")
    /// Powered by
    internal static let resultsSource = L10n.tr("Localizable", "search_instructions.results_source", fallback: "Powered by")
    /// Start Exploring!
    internal static let title = L10n.tr("Localizable", "search_instructions.title", fallback: "Start Exploring!")
  }
  internal enum SearchLocationDisabled {
    /// Go to Settings
    internal static let ctaTitle = L10n.tr("Localizable", "search_location_disabled.cta_title", fallback: "Go to Settings")
    /// To show you the best nearby places, please enable location services in Settings.
    internal static let description = L10n.tr("Localizable", "search_location_disabled.description", fallback: "To show you the best nearby places, please enable location services in Settings.")
    /// Where Am I?
    internal static let title = L10n.tr("Localizable", "search_location_disabled.title", fallback: "Where Am I?")
  }
  internal enum SearchNoInternet {
    /// Looks like you're not connected to the internet; please reconnect to search for great places!
    internal static let description = L10n.tr("Localizable", "search_no_internet.description", fallback: "Looks like you're not connected to the internet; please reconnect to search for great places!")
    /// No internet
    internal static let title = L10n.tr("Localizable", "search_no_internet.title", fallback: "No internet")
  }
  internal enum SearchNoResults {
    /// Try entering different search terms above...there's somewhere great nearby!
    internal static let description = L10n.tr("Localizable", "search_no_results.description", fallback: "Try entering different search terms above...there's somewhere great nearby!")
    /// No Results Found
    internal static let title = L10n.tr("Localizable", "search_no_results.title", fallback: "No Results Found")
  }
  internal enum SearchResults {
    /// Call: %@
    internal static func callNumber(_ p1: String) -> String {
      return L10n.tr("Localizable", "search_results.call_number", p1, fallback: "Call: %@")
    }
    /// $
    internal static let currencySymbol = L10n.tr("Localizable", "search_results.currency_symbol", fallback: "$")
    /// %d reviews
    internal static func numRatingsPlural(_ p1: Int) -> String {
      return L10n.tr("Localizable", "search_results.num_ratings_plural", p1, fallback: "%d reviews")
    }
    /// %d review
    internal static func numRatingsSingular(_ p1: Int) -> String {
      return L10n.tr("Localizable", "search_results.num_ratings_singular", p1, fallback: "%d review")
    }
  }
  internal enum SearchRetry {
    /// Try again
    internal static let ctaTitle = L10n.tr("Localizable", "search_retry.cta_title", fallback: "Try again")
    /// Sorry, there was an error on our end.
    internal static let description = L10n.tr("Localizable", "search_retry.description", fallback: "Sorry, there was an error on our end.")
    /// Pardon the hiccup...
    internal static let title = L10n.tr("Localizable", "search_retry.title", fallback: "Pardon the hiccup...")
  }
  internal enum SettingsHeaders {
    /// SEARCH DISTANCE
    internal static let distanceSectionTitle = L10n.tr("Localizable", "settings_headers.distance_section_title", fallback: "SEARCH DISTANCE")
    /// SORT RESULTS BY
    internal static let sortSectionTitle = L10n.tr("Localizable", "settings_headers.sort_section_title", fallback: "SORT RESULTS BY")
  }
  internal enum SettingsMeasurementSystem {
    /// U.S
    internal static let imperial = L10n.tr("Localizable", "settings_measurement_system.imperial", fallback: "U.S")
    /// Metric
    internal static let metric = L10n.tr("Localizable", "settings_measurement_system.metric", fallback: "Metric")
  }
  internal enum SettingsSortPreference {
    /// Best match
    internal static let bestMatchTitle = L10n.tr("Localizable", "settings_sort_preference.best_match_title", fallback: "Best match")
    /// Distance
    internal static let distanceTitle = L10n.tr("Localizable", "settings_sort_preference.distance_title", fallback: "Distance")
    /// Rating
    internal static let ratingTitle = L10n.tr("Localizable", "settings_sort_preference.rating_title", fallback: "Rating")
    /// Number of reviews
    internal static let reviewCountTitle = L10n.tr("Localizable", "settings_sort_preference.review_count_title", fallback: "Number of reviews")
  }
}
// swiftlint:enable explicit_type_interface function_parameter_count identifier_name line_length
// swiftlint:enable nesting type_body_length type_name vertical_whitespace_opening_braces

// MARK: - Implementation Details

extension L10n {
  private static func tr(_ table: String, _ key: String, _ args: CVarArg..., fallback value: String) -> String {
    let format = BundleToken.bundle.localizedString(forKey: key, value: value, table: table)
    return String(format: format, locale: Locale.current, arguments: args)
  }
}

// swiftlint:disable convenience_type
private final class BundleToken {
  static let bundle: Bundle = {
    #if SWIFT_PACKAGE
    return Bundle.module
    #else
    return Bundle(for: BundleToken.self)
    #endif
  }()
}
// swiftlint:enable convenience_type
