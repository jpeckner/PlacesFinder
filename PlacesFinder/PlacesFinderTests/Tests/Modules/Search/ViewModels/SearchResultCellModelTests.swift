//
//  SearchResultCellModelTests.swift
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

class SearchResultCellModelTests: QuickSpec {

    // swiftlint:disable implicitly_unwrapped_optional
    override func spec() {

        var mockFormatter: SearchCopyFormatterProtocolMock!

        var result: SearchResultCellModel!

        beforeEach {
            mockFormatter = SearchCopyFormatterProtocolMock()
            mockFormatter.formatPricingReturnValue = "formatPricingReturnValue"
        }

        describe("init(summaryModel:formatter:)") {
            let stubSummaryModel = SearchSummaryModel.stubValue()

            beforeEach {
                result = SearchResultCellModel(model: stubSummaryModel,
                                               copyFormatter: mockFormatter)
            }

            it("inits a viewmodel with the model's name...") {
                expect(result.name) == stubSummaryModel.name
            }

            it("...and with the model's ratings average...") {
                expect(result.ratingsAverage) == stubSummaryModel.ratings.average
            }

            it("...and with the ratings returned by mockCopyFormatter.formatRatings()...") {
                expect(result.pricing) == "formatPricingReturnValue"
            }

            it("...and with the model's image") {
                expect(result.image) == stubSummaryModel.image
            }
        }

    }

}
