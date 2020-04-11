//
//  SearchResultViewModelBuilderTests.swift
//  PlacesFinder
//
//  Created by Justin Peckner.
//  Copyright © 2020 Justin Peckner. All rights reserved.
//

import Nimble
import Quick
import Shared
import SwiftDux

class SearchResultViewModelBuilderTests: QuickSpec {

    private enum StubViewModelAction: Action {
        case detailEntity
    }

    // swiftlint:disable implicitly_unwrapped_optional
    override func spec() {

        let stubEntityModel = SearchEntityModel.stubValue()
        let stubResultCellModel = SearchResultCellModel.stubValue()
        let stubCopyContent = SearchResultsCopyContent.stubValue()

        var mockStore: MockAppStore!
        var mockResultCellModelBuilder: SearchResultCellModelBuilderProtocolMock!
        var mockSearchActionPrism: SearchActionPrismProtocolMock!
        var mockFormatter: SearchCopyFormatterProtocolMock!

        var sut: SearchResultViewModelBuilder!

        beforeEach {
            mockStore = MockAppStore()

            mockResultCellModelBuilder = SearchResultCellModelBuilderProtocolMock()
            mockResultCellModelBuilder.buildViewModelResultsCopyContentReturnValue = stubResultCellModel

            mockSearchActionPrism = SearchActionPrismProtocolMock()
            mockSearchActionPrism.detailEntityActionReturnValue = StubViewModelAction.detailEntity

            mockFormatter = SearchCopyFormatterProtocolMock()

            sut = SearchResultViewModelBuilder(store: mockStore,
                                               actionPrism: mockSearchActionPrism,
                                               copyFormatter: mockFormatter,
                                               resultCellModelBuilder: mockResultCellModelBuilder)
        }

        describe("buildViewModel()") {

            var result: SearchResultViewModel!

            beforeEach {
                result = sut.buildViewModel(stubEntityModel,
                                            resultsCopyContent: stubCopyContent)
            }

            it("calls mockResultCellModelBuilder with expected method and args") {
                let receivedArgs = mockResultCellModelBuilder.buildViewModelResultsCopyContentReceivedArguments
                expect(receivedArgs?.model) == stubEntityModel
                expect(receivedArgs?.resultsCopyContent) == stubCopyContent
            }

            it("returns the SearchResultCellModel returned by mockResultCellModelBuilder") {
                expect(result.cellModel) == stubResultCellModel
            }

            it("includes the Action returned by mockSearchActionPrism") {
                expect(mockStore.dispatchedActions.isEmpty) == true
                result.dispatchDetailEntityAction()
                expect(mockStore.dispatchedActions.first as? StubViewModelAction) == .detailEntity
            }

        }

    }

}
