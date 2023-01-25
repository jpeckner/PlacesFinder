//
//  SearchResultCellModelBuilderTests.swift
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
                expect(result.image.url) == stubEntityModel.image
            }
        }

    }

}
