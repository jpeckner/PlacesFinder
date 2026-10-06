//
//  SearchInputPropsBuilderTests.swift
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
import SwiftDux

// swiftlint:disable blanket_disable_command
// swiftlint:disable implicitly_unwrapped_optional
class SearchInputPropsBuilderTests: AsyncSpec {

    override class func spec() {

        let stubInputParams = SearchInputParams.stubValue()
        let stubInputCopyContent = SearchInputCopyContent.stubValue()
        let stubContentProps = SearchInputContentProps.stubValue()

        var mockSearchActivityActionPrism: SearchActivityActionPrismProtocolMock!
        var mockContentPropsBuilder: SearchInputContentPropsBuilderProtocolMock!

        var sut: SearchInputPropsBuilder!
        var result: SearchInputProps!

        beforeEach {
            mockSearchActivityActionPrism = SearchActivityActionPrismProtocolMock()
            mockSearchActivityActionPrism.updateEditingActionClosure = { editEvent in .updateInputEditing(editEvent) }

            mockContentPropsBuilder = SearchInputContentPropsBuilderProtocolMock()
            mockContentPropsBuilder.buildPropsKeywordsBarStateCopyContentReturnValue = stubContentProps

            sut = SearchInputPropsBuilder(actionPrism: mockSearchActivityActionPrism,
                                          contentPropsBuilder: mockContentPropsBuilder)
        }

        describe("buildProps()") {

            beforeEach {
                result = sut.buildProps(
                    inputParams: stubInputParams,
                    copyContent: stubInputCopyContent
                )
            }

            it("calls mockContentPropsBuilder with expected method and args") {
                let receivedArgs = mockContentPropsBuilder.buildPropsKeywordsBarStateCopyContentReceivedArguments
                expect(receivedArgs?.keywords) == stubInputParams.params?.keywords
                expect(receivedArgs?.barState) == stubInputParams.barState
                expect(receivedArgs?.copyContent) == stubInputCopyContent
            }

            it("returns the content props built by mockContentPropsBuilder") {
                expect(result.content) == stubContentProps
            }

            it("includes the end-editing action returned by mockSearchActivityActionPrism as coverTappedAction") {
                expect(mockSearchActivityActionPrism.updateEditingActionReceivedEditEvent) == .endedEditing
                expect(result.coverTappedAction.value) == .searchActivity(.updateInputEditing(.endedEditing))
            }

        }

    }

}
// swiftlint:enable blanket_disable_command
