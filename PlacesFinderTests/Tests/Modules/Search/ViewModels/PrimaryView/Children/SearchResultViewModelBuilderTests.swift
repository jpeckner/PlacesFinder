//
//  SearchResultViewModelBuilderTests.swift
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

import Combine
import Nimble
import Quick
import Shared
import SwiftDux

class SearchResultViewModelBuilderTests: QuickSpec {

    // swiftlint:disable implicitly_unwrapped_optional
    // swiftlint:disable line_length
    override func spec() {

        let stubEntityModel = SearchEntityModel.stubValue()
        let stubResultCellModel = SearchResultCellModel.stubValue()
        let stubCopyContent = SearchResultsCopyContent.stubValue()

        var mockActionSubscriber: MockSubscriber<Search.Action>!
        var mockResultCellModelBuilder: SearchResultCellModelBuilderProtocolMock!
        var mockSearchActivityActionPrism: SearchActivityActionPrismProtocolMock!

        var sut: SearchResultViewModelBuilder!

        beforeEach {
            mockActionSubscriber = MockSubscriber()

            mockResultCellModelBuilder = SearchResultCellModelBuilderProtocolMock()
            mockResultCellModelBuilder.buildViewModelModelResultsCopyContentColoringsReturnValue = stubResultCellModel

            mockSearchActivityActionPrism = SearchActivityActionPrismProtocolMock()
            mockSearchActivityActionPrism.detailEntityActionReturnValue = .detailedEntity(stubEntityModel)

            sut = SearchResultViewModelBuilder(actionSubscriber: AnySubscriber(mockActionSubscriber),
                                               actionPrism: mockSearchActivityActionPrism,
                                               resultCellModelBuilder: mockResultCellModelBuilder)
        }

        describe("buildViewModel()") {

            var result: SearchResultViewModel!

            beforeEach {
                result = sut.buildViewModel(model: stubEntityModel,
                                            resultsCopyContent: stubCopyContent,
                                            colorings: AppColorings.defaultColorings.searchResults)
            }

            it("calls mockResultCellModelBuilder with expected method and args") {
                let receivedArgs = mockResultCellModelBuilder.buildViewModelModelResultsCopyContentColoringsReceivedArguments
                expect(receivedArgs?.model) == stubEntityModel
                expect(receivedArgs?.resultsCopyContent) == stubCopyContent
            }

            it("returns the SearchResultCellModel returned by mockResultCellModelBuilder") {
                expect(result.cellModel) == stubResultCellModel
            }

            it("includes the Action returned by mockSearchActivityActionPrism") {
                expect(mockActionSubscriber.receivedInputs.isEmpty) == true
                result.dispatchDetailEntityAction()
                expect(mockActionSubscriber.receivedInputs.first) == .searchActivity(.detailedEntity(stubEntityModel))
            }

        }

    }

}
