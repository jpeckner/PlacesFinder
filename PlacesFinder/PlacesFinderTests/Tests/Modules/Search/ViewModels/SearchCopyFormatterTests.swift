//
//  SearchCopyFormatterTests.swift
//  PlacesFinderTests
//
//  Created by Justin Peckner.
//  Copyright © 2019 Justin Peckner. All rights reserved.
//

import Nimble
#if DEBUG
@testable import PlacesFinder
#endif
import Quick
import Shared
import SharedTestComponents

class SearchCopyFormatterTests: QuickSpec {

    // swiftlint:disable function_body_length
    // swiftlint:disable implicitly_unwrapped_optional
    override func spec() {
        let stubCopyContent = SearchResultsCopyContent(
            currencySymbol: "+",
            callNumberFormatString: "callNumberFormatString - %@",
            numRatingsSingularFormatString: "numRatingsSingularFormatString - %d",
            numRatingsPluralFormatString: "numRatingsPluralFormatString - %d"
        )

        var formatter: SearchCopyFormatter!

        beforeEach {
            formatter = SearchCopyFormatter(resultsCopyContent: stubCopyContent)
        }

        describe("formatAddress") {
            let stubAddressLines = PlaceLookupAddressLines.stubValue()

            var result: NonEmptyString!

            beforeEach {
                result = formatter.formatAddress(stubAddressLines)
            }

            it("returns its expected value") {
                expect(result) == .stubValue("stubAddressLine1\nstubAddressLine2")
            }
        }

        describe("formatCallablePhoneNumber") {
            var result: String!

            beforeEach {
                result = formatter.formatCallablePhoneNumber(.stubValue("stubPhoneNumber"))
            }

            it("returns the phone number formatted into the format string") {
                expect(result) == "callNumberFormatString - stubPhoneNumber"
            }
        }

        describe("formatNonCallablePhoneNumber") {
            var result: String!

            beforeEach {
                result = formatter.formatNonCallablePhoneNumber(.stubValue("stubPhoneNumber"))
            }

            it("returns the phone number unchanged") {
                expect(result) == "stubPhoneNumber"
            }
        }

        describe("formatRatings") {
            var result: String!

            context("when the arg value is 1") {
                beforeEach {
                    result = formatter.formatRatings(1)
                }

                it("returns the number of ratings formatted into numRatingsSingularFormatString") {
                    expect(result) == "numRatingsSingularFormatString - 1"
                }
            }

            context("else") {
                beforeEach {
                    result = formatter.formatRatings(2)
                }

                it("returns the number of ratings formatted into numRatingsPluralFormatString") {
                    expect(result) == "numRatingsPluralFormatString - 2"
                }
            }
        }

        describe("formatPricing") {
            var result: String!

            beforeEach {
                result = formatter.formatPricing(PlaceLookupPricing(count: 5, maximum: 10))
            }

            it("returns the currency symbol in copyContent, repeated count times") {
                expect(result) == "+++++"
            }
        }

    }

}
