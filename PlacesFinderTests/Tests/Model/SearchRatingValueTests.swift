//
//  SearchRatingValueTests.swift
//  PlacesFinderTests
//
//  Created by Justin Peckner.
//  Copyright © 2020 Justin Peckner. All rights reserved.
//

import Nimble
import Quick
import Shared

class SearchRatingValueTests: QuickSpec {

    // swiftlint:disable implicitly_unwrapped_optional
    override func spec() {

        var result: SearchRatingValue!

        describe("init()") {

            let expectedResults: [Int: SearchRatingValue] = [
                20: .one,
                30: .oneAndAHalf,
                40: .two,
                50: .twoAndAHalf,
                60: .three,
                70: .threeAndAHalf,
                80: .four,
                90: .fourAndAHalf,
                100: .five
            ]

            for (percentage, expectedValue) in expectedResults {

                context("when the rating percentage is \(percentage)") {
                    beforeEach {
                        result = SearchRatingValue(averageRating: Percentage(fromPercentageInt: percentage))
                    }

                    it("returns \(expectedValue)") {
                        expect(result) == expectedValue
                    }
                }

            }

        }

    }

}
