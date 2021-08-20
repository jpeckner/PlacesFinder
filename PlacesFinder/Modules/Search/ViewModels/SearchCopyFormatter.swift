//
//  SearchCopyFormatter.swift
//  PlacesFinder
//
//  Created by Justin Peckner.
//  Copyright © 2019 Justin Peckner. All rights reserved.
//

import Foundation
import Shared

protocol SearchCopyFormatterProtocol: AutoMockable {
    func formatAddress(_ address: PlaceLookupAddressLines) -> NonEmptyString

    func formatCallablePhoneNumber(_ resultsCopyContent: SearchResultsCopyContent,
                                   displayPhone: NonEmptyString) -> String
    func formatNonCallablePhoneNumber(_ displayPhone: NonEmptyString) -> String

    func formatRatings(_ resultsCopyContent: SearchResultsCopyContent,
                       numRatings: Int) -> String
    func formatPricing(_ resultsCopyContent: SearchResultsCopyContent,
                       pricing: PlaceLookupPricing) -> String
}

class SearchCopyFormatter: SearchCopyFormatterProtocol {}

extension SearchCopyFormatter {

    func formatAddress(_ addressLines: PlaceLookupAddressLines) -> NonEmptyString {
        return addressLines.joined("\n")
    }

}

extension SearchCopyFormatter {

    func formatCallablePhoneNumber(_ resultsCopyContent: SearchResultsCopyContent,
                                   displayPhone: NonEmptyString) -> String {
        return String(format: resultsCopyContent.callNumberFormatString, displayPhone.value)
    }

    func formatNonCallablePhoneNumber(_ displayPhone: NonEmptyString) -> String {
        return displayPhone.value
    }

}

extension SearchCopyFormatter {

    func formatRatings(_ resultsCopyContent: SearchResultsCopyContent,
                       numRatings: Int) -> String {
        let formatString = numRatings == 1 ?
            resultsCopyContent.numRatingsSingularFormatString
            : resultsCopyContent.numRatingsPluralFormatString
        return String(format: formatString, numRatings)
    }

    func formatPricing(_ resultsCopyContent: SearchResultsCopyContent,
                       pricing: PlaceLookupPricing) -> String {
        return String(repeating: resultsCopyContent.currencySymbol,
                      count: pricing.count)
    }

}
