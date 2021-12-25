//
//  SearchCopyFormatterTests.swift
//  PlacesFinderTests
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

import Nimble
import Quick
import Shared
import SharedTestComponents

class SearchCopyFormatterTests: QuickSpec {

    // swiftlint:disable function_body_length
    // swiftlint:disable implicitly_unwrapped_optional
    override func spec() {
        let stubCopyContent = SearchResultsCopyContent.stubValue()

        var formatter: SearchCopyFormatter!

        beforeEach {
            formatter = SearchCopyFormatter()
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
                result = formatter.formatCallablePhoneNumber(stubCopyContent,
                                                             displayPhone: .stubValue("stubPhoneNumber"))
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
                    result = formatter.formatRatings(stubCopyContent, numRatings: 1)
                }

                it("returns the number of ratings formatted into numRatingsSingularFormatString") {
                    expect(result) == "numRatingsSingularFormatString - 1"
                }
            }

            context("else") {
                beforeEach {
                    result = formatter.formatRatings(stubCopyContent, numRatings: 2)
                }

                it("returns the number of ratings formatted into numRatingsPluralFormatString") {
                    expect(result) == "numRatingsPluralFormatString - 2"
                }
            }
        }

        describe("formatPricing") {
            var result: String!

            beforeEach {
                result = formatter.formatPricing(stubCopyContent,
                                                 pricing: PlaceLookupPricing(count: 5, maximum: 10))
            }

            it("returns the currency symbol in copyContent, repeated count times") {
                expect(result) == "+++++"
            }
        }

    }

}
