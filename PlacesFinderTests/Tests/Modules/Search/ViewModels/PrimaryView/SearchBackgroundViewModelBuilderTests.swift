//
//  SearchBackgroundViewModelBuilderTests.swift
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
import SharedTestComponents
import SwiftDux

// swiftlint:disable blanket_disable_command
// swiftlint:disable implicitly_unwrapped_optional
// swiftlint:disable line_length
class SearchBackgroundViewModelBuilderTests: QuickSpec {

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
            mockContentViewModelBuilder.buildViewModelKeywordsBarStateCopyContentReturnValue = stubContentViewModel

            mockInstructionsViewModelBuilder = SearchInstructionsViewModelBuilderProtocolMock()
            mockInstructionsViewModelBuilder.buildViewModelCopyContentColoringsReturnValue = stubInstructionsViewModel

            sut = SearchBackgroundViewModelBuilder(contentViewModelBuilder: mockContentViewModelBuilder,
                                                   instructionsViewModelBuilder: mockInstructionsViewModelBuilder)
        }

        describe("buildViewModel()") {

            beforeEach {
                result = sut.buildViewModel(keywords: stubKeywords,
                                            appCopyContent: stubAppCopyContent,
                                            colorings: AppColorings.defaultColorings.standard)
            }

            it("calls mockContentViewModelBuilder with expected method and args") {
                let receivedArgs = mockContentViewModelBuilder.buildViewModelKeywordsBarStateCopyContentReceivedArguments
                expect(receivedArgs?.keywords) == stubKeywords
                expect(receivedArgs?.barState) == .isShowing(isEditing: false)
                expect(receivedArgs?.copyContent) == stubAppCopyContent.searchInput
            }

            it("calls mockInstructionsViewModelBuilder with expected method and args") {
                expect(mockInstructionsViewModelBuilder.buildViewModelCopyContentColoringsReceivedArguments?.copyContent) == stubAppCopyContent.searchInstructions
            }

            it("returns the expected value") {
                expect(result.contentViewModel) == stubContentViewModel
                expect(result.instructionsViewModel) == stubInstructionsViewModel
            }

        }

    }

}
// swiftlint:enable blanket_disable_command
