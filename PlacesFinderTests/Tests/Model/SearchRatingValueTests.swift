//
//  SearchRatingValueTests.swift
//  PlacesFinderTests
//
//  Copyright (c) 2020 Justin Peckner
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

// swiftlint:disable blanket_disable_command
// swiftlint:disable implicitly_unwrapped_optional
class SearchRatingValueTests: QuickSpec {

    override func spec() {

        describe("SearchRatingValue.init()") {

            var result: SearchRatingValue!

            let expectedResults: [Double: SearchRatingValue] = [
                1.0: .one,
                1.5: .oneAndAHalf,
                2.0: .two,
                2.5: .twoAndAHalf,
                3.0: .three,
                3.5: .threeAndAHalf,
                4.0: .four,
                4.5: .fourAndAHalf,
                5.0: .five,
                // Values that aren't a multiple of 0.5 are rounded to the nearest one
                3.8: .four,
                4.2: .four,
                4.3: .fourAndAHalf,
            ]

            for (averageRating, expectedValue) in expectedResults {

                context("when the average rating is \(averageRating)") {
                    beforeEach {
                        result = SearchRatingValue(averageRating: averageRating)
                    }

                    it("returns \(expectedValue)") {
                        expect(result) == expectedValue
                    }
                }

            }

            for averageRating in [0.0, 0.7, 5.3] {

                context("when the average rating is \(averageRating)") {
                    beforeEach {
                        result = SearchRatingValue(averageRating: averageRating)
                    }

                    it("returns nil") {
                        expect(result) == nil
                    }
                }

            }

        }

        describe("SearchRatings.init()") {

            context("when the averageRating arg can't be converted to a SearchRatingValue") {
                it("returns nil") {
                    expect(SearchRatings(averageRating: 0.0, numRatings: 123)) == nil
                }
            }

            context("else") {
                it("returns a SearchRatings with the converted average and the numRatings arg") {
                    expect(SearchRatings(averageRating: 4.4, numRatings: 123))
                        == SearchRatings(average: .fourAndAHalf, numRatings: 123)
                }
            }

        }

    }

}
// swiftlint:enable blanket_disable_command
