//
//  SearchCopyFormatter.swift
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
