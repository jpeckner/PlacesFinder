//
//  SearchLookupPropsBuilderTests.swift
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
import SwiftDux

// swiftlint:disable blanket_disable_command
// swiftlint:disable implicitly_unwrapped_optional
// swiftlint:disable line_length
class SearchLookupPropsBuilderTests: AsyncSpec {

    override class func spec() {

        let stubInputParams = SearchInputParams.stubValue()
        let stubSearchActivityState = Search.ActivityState(loadState: .idle,
                                                           inputParams: stubInputParams,
                                                           detailedEntity: .stubValue())

        var stubInputProps: SearchInputProps!
        var mockInputPropsBuilder: SearchInputPropsBuilderProtocolMock!
        var mockChildBuilder: SearchLookupChildBuilderProtocolMock!

        var locationBlockCalled: Bool!
        var sut: SearchLookupPropsBuilder!
        var result: SearchLookupProps!

        beforeEach {
            locationBlockCalled = false

            stubInputProps = SearchInputProps(
                content: .stubValue(),
                coverTappedAction: .searchActivity(.updateInputEditing(.endedEditing))
            )
            mockInputPropsBuilder = SearchInputPropsBuilderProtocolMock()
            mockInputPropsBuilder.buildPropsInputParamsReturnValue = stubInputProps

            mockChildBuilder = SearchLookupChildBuilderProtocolMock()
            mockChildBuilder.buildChildLoadStateAppSkinLocationUpdateRequestBlockReturnValue = .progress(.stubValue())

            sut = SearchLookupPropsBuilder(inputPropsBuilder: mockInputPropsBuilder,
                                           childBuilder: mockChildBuilder)
        }

        describe("buildProps()") {

            beforeEach {
                result = sut.buildProps(
                    searchActivityState: stubSearchActivityState,
                    appSkin: .stubValue()
                ) {
                    locationBlockCalled = true
                    return .success(.stubValue())
                }
            }

            it("calls mockInputPropsBuilder with expected method and args") {
                expect(mockInputPropsBuilder.buildPropsInputParamsReceivedInputParams) == stubInputParams
            }

            it("calls mockChildBuilder with expected method and args") {
                let receivedArgs = mockChildBuilder.buildChildLoadStateAppSkinLocationUpdateRequestBlockReceivedArguments
                expect(receivedArgs?.loadState) == stubSearchActivityState.loadState

                expect(locationBlockCalled) == false
                _ = await receivedArgs?.locationUpdateRequestBlock()
                expect(locationBlockCalled) == true
            }

            it("returns the expected value") {
                expect(result.inputProps) == stubInputProps
                expect(result.child) == .progress(.stubValue())
            }

        }

    }

}
// swiftlint:enable blanket_disable_command
