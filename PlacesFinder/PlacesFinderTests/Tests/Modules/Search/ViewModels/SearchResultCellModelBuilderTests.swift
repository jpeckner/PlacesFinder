//
//  SearchResultCellModelBuilderTests.swift
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

class SearchResultCellModelBuilderTests: QuickSpec {

    // swiftlint:disable implicitly_unwrapped_optional
    override func spec() {

        var mockFormatter: SearchCopyFormatterProtocolMock!

        var sut: SearchResultCellModelBuilder!

        beforeEach {
            mockFormatter = SearchCopyFormatterProtocolMock()
            mockFormatter.formatPricingPricingReturnValue = "formatPricingPricingReturnValue"

            sut = SearchResultCellModelBuilder(copyFormatter: mockFormatter)
        }

        describe("buildViewModel()") {
            let stubEntityModel = SearchEntityModel.stubValue()
            let stubCopyContent = SearchResultsCopyContent.stubValue()

            var result: SearchResultCellModel!

            beforeEach {
                result = sut.buildViewModel(stubEntityModel,
                                            resultsCopyContent: stubCopyContent)
            }

            it("calls mockFormatter with expected method and args") {
                let receivedArgs = mockFormatter.formatPricingPricingReceivedArguments
                expect(receivedArgs?.resultsCopyContent) == stubCopyContent
                expect(receivedArgs?.pricing) == stubEntityModel.pricing
            }

            it("inits a viewmodel with the model's name...") {
                expect(result.name) == stubEntityModel.name
            }

            it("...and with the model's ratings average...") {
                expect(result.ratingsAverage) == stubEntityModel.ratings.average
            }

            it("...and with the ratings returned by mockCopyFormatter.formatRatings()...") {
                expect(result.pricing) == "formatPricingPricingReturnValue"
            }

            it("...and with the model's image") {
                expect(result.image) == stubEntityModel.image
            }
        }

    }

}
