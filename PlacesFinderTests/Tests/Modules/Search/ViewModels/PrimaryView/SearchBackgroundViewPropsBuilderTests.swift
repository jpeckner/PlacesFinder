//
//  SearchBackgroundViewPropsBuilderTests.swift
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
class SearchBackgroundViewPropsBuilderTests: AsyncSpec {

    override class func spec() {

        let stubKeywords = NonEmptyString.stubValue("stubInputKeywords")
        let stubContentProps = SearchInputContentProps.stubValue()
        let stubInstructionsProps = SearchInstructionsProps.stubValue()

        var mockContentPropsBuilder: SearchInputContentPropsBuilderProtocolMock!
        var mockInstructionsPropsBuilder: SearchInstructionsPropsBuilderProtocolMock!

        var sut: SearchBackgroundViewPropsBuilder!
        var result: SearchBackgroundViewProps!

        beforeEach {
            mockContentPropsBuilder = SearchInputContentPropsBuilderProtocolMock()
            mockContentPropsBuilder.buildPropsKeywordsBarStateReturnValue = stubContentProps

            mockInstructionsPropsBuilder = SearchInstructionsPropsBuilderProtocolMock()
            mockInstructionsPropsBuilder.buildPropsColoringsReturnValue = stubInstructionsProps

            sut = SearchBackgroundViewPropsBuilder(contentPropsBuilder: mockContentPropsBuilder,
                                                   instructionsPropsBuilder: mockInstructionsPropsBuilder)
        }

        describe("buildProps()") {

            beforeEach {
                result = sut.buildProps(keywords: stubKeywords,
                                        colorings: AppColorings.defaultColorings.standard)
            }

            it("calls mockContentPropsBuilder with expected method and args") {
                let receivedArgs = mockContentPropsBuilder.buildPropsKeywordsBarStateReceivedArguments
                expect(receivedArgs?.keywords) == stubKeywords
                expect(receivedArgs?.barState) == .isShowing(isEditing: false)
            }

            it("calls mockInstructionsPropsBuilder with expected method and args") {
                expect(mockInstructionsPropsBuilder.buildPropsColoringsReceivedColorings) == AppColorings.defaultColorings.standard
            }

            it("returns the expected value") {
                expect(result.contentProps) == stubContentProps
                expect(result.instructionsProps) == stubInstructionsProps
            }

        }

    }

}
// swiftlint:enable blanket_disable_command
