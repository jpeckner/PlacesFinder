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

    func formatCallablePhoneNumber(_ displayPhone: NonEmptyString) -> String
    func formatNonCallablePhoneNumber(_ displayPhone: NonEmptyString) -> String

    func formatRatings(_ numRatings: Int) -> String
    func formatPricing(_ pricing: PlaceLookupPricing) -> String
}

class SearchCopyFormatter: SearchCopyFormatterProtocol {
    private let resultsCopyContent: SearchResultsCopyContent

    init(resultsCopyContent: SearchResultsCopyContent) {
        self.resultsCopyContent = resultsCopyContent
    }
}

extension SearchCopyFormatter {

    func formatAddress(_ addressLines: PlaceLookupAddressLines) -> NonEmptyString {
        return addressLines.joined("\n")
    }

}

extension SearchCopyFormatter {

    func formatCallablePhoneNumber(_ displayPhone: NonEmptyString) -> String {
        return String(format: resultsCopyContent.callNumberFormatString, displayPhone.value)
    }

    func formatNonCallablePhoneNumber(_ displayPhone: NonEmptyString) -> String {
        return displayPhone.value
    }

}

extension SearchCopyFormatter {

    func formatRatings(_ numRatings: Int) -> String {
        let formatString = numRatings == 1 ?
            resultsCopyContent.numRatingsSingularFormatString
            : resultsCopyContent.numRatingsPluralFormatString
        return String(format: formatString, numRatings)
    }

    func formatPricing(_ pricing: PlaceLookupPricing) -> String {
        return String(repeating: resultsCopyContent.currencySymbol,
                      count: pricing.count)
    }

}
