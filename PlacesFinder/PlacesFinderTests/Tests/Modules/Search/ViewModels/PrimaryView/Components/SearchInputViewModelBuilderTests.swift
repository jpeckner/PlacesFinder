//
//  SearchInputViewModelBuilderTests.swift
//  PlacesFinder
//
//  Created by Justin Peckner.
//  Copyright © 2020 Justin Peckner. All rights reserved.
//

import Nimble
import Quick

class SearchInputViewModelBuilderTests: QuickSpec {

    // swiftlint:disable implicitly_unwrapped_optional
    // swiftlint:disable line_length
    override func spec() {

        let stubInputParams = SearchInputParams.stubValue()
        let stubInputCopyContent = SearchInputCopyContent.stubValue()
        let stubContentViewModel = SearchInputContentViewModel.stubValue()

        var mockStore: MockAppStore!
        var mockSearchActionPrism: SearchActionPrismProtocolMock!
        var mockContentViewModelBuilder: SearchInputContentViewModelBuilderProtocolMock!

        var sut: SearchInputViewModelBuilder!
        var result: SearchInputViewModel!

        beforeEach {
            mockStore = MockAppStore()

            mockSearchActionPrism = SearchActionPrismProtocolMock()

            mockContentViewModelBuilder = SearchInputContentViewModelBuilderProtocolMock()
            mockContentViewModelBuilder.buildViewModelKeywordsIsEditingCopyContentReturnValue = stubContentViewModel

            sut = SearchInputViewModelBuilder(store: mockStore,
                                              actionPrism: mockSearchActionPrism,
                                              contentViewModelBuilder: mockContentViewModelBuilder)
        }

        describe("buildViewModel()") {

            beforeEach {
                result = sut.buildDispatchingViewModel(stubInputParams,
                                                       copyContent: stubInputCopyContent) { _ in }
            }

            it("calls mockContentViewModelBuilder with expected method and args") {
                let receivedArgs = mockContentViewModelBuilder.buildViewModelKeywordsIsEditingCopyContentReceivedArguments
                expect(receivedArgs?.keywords) == stubInputParams.params?.keywords
                expect(receivedArgs?.isEditing) == stubInputParams.isEditing
                expect(receivedArgs?.copyContent) == stubInputCopyContent
            }

            it("returns the viewmodel built by mockContentViewModelBuilder") {
                expect(result.content) == stubContentViewModel
            }

        }

    }

}
