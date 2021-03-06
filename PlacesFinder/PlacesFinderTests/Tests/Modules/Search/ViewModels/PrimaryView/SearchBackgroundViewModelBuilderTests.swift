//
//  SearchBackgroundViewModelBuilderTests.swift
//  PlacesFinderTests
//
//  Created by Justin Peckner.
//  Copyright © 2020 Justin Peckner. All rights reserved.
//

import Nimble
import Quick
import Shared
import SharedTestComponents
import SwiftDux

class SearchBackgroundViewModelBuilderTests: QuickSpec {

    // swiftlint:disable implicitly_unwrapped_optional
    // swiftlint:disable line_length
    override func spec() {

        let stubKeywords = NonEmptyString.stubValue("stubInputKeywords")
        let stubAppCopyContent = AppCopyContent.stubValue()
        let stubContentViewModel = SearchInputContentViewModel.stubValue()
        let stubInstructionsViewModel = SearchInstructionsViewModel.stubValue()

        var mockContentViewModelBuilder: SearchInputContentViewModelBuilderProtocolMock!
        var mockInstructionsViewModelBuilder: SearchInstructionsViewModelBuilderProtocolMock!

        var sut: SearchBackgroundViewModelBuilder!
        var result: SearchBackgroundViewModel!

        beforeEach {
            mockContentViewModelBuilder = SearchInputContentViewModelBuilderProtocolMock()
            mockContentViewModelBuilder.buildViewModelKeywordsIsEditingCopyContentReturnValue = stubContentViewModel

            mockInstructionsViewModelBuilder = SearchInstructionsViewModelBuilderProtocolMock()
            mockInstructionsViewModelBuilder.buildViewModelCopyContentReturnValue = stubInstructionsViewModel

            sut = SearchBackgroundViewModelBuilder(contentViewModelBuilder: mockContentViewModelBuilder,
                                                   instructionsViewModelBuilder: mockInstructionsViewModelBuilder)
        }

        describe("buildViewModel()") {

            beforeEach {
                result = sut.buildViewModel(stubKeywords,
                                            appCopyContent: stubAppCopyContent)
            }

            it("calls mockContentViewModelBuilder with expected method and args") {
                let receivedArgs = mockContentViewModelBuilder.buildViewModelKeywordsIsEditingCopyContentReceivedArguments
                expect(receivedArgs?.keywords) == stubKeywords
                expect(receivedArgs?.isEditing) == false
                expect(receivedArgs?.copyContent) == stubAppCopyContent.searchInput
            }

            it("calls mockInstructionsViewModelBuilder with expected method and args") {
                expect(mockInstructionsViewModelBuilder.buildViewModelCopyContentReceivedCopyContent) == stubAppCopyContent.searchInstructions
            }

            it("returns the expected value") {
                expect(result.contentViewModel) == stubContentViewModel
                expect(result.instructionsViewModel) == stubInstructionsViewModel
            }

        }

    }

}
