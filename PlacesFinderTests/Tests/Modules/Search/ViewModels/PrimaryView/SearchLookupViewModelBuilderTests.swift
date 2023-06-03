//
//  SearchLookupViewModelBuilderTests.swift
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

class SearchLookupViewModelBuilderTests: QuickSpec {

    // swiftlint:disable implicitly_unwrapped_optional
    // swiftlint:disable line_length
    override func spec() {

        let stubAppCopyContent = AppCopyContent.stubValue()
        let stubInputParams = SearchInputParams.stubValue()
        let stubSearchActivityState = Search.ActivityState(loadState: .idle,
                                                           inputParams: stubInputParams,
                                                           detailedEntity: .stubValue())

        var mockActionSubscriber: MockSubscriber<Search.Action>!
        var mockSearchActivityActionPrism: SearchActivityActionPrismProtocolMock!
        var stubInputViewModel: SearchInputViewModel!
        var mockInputViewModelBuilder: SearchInputViewModelBuilderProtocolMock!
        var mockChildBuilder: SearchLookupChildBuilderProtocolMock!

        var locationBlockCalled: Bool!
        var sut: SearchLookupViewModelBuilder!
        var result: SearchLookupViewModel!

        func locationUpdateStub() async -> LocationRequestResult {
            locationBlockCalled = true
            return .success(.stubValue())
        }

        beforeEach {
            mockActionSubscriber = MockSubscriber()
            mockSearchActivityActionPrism = SearchActivityActionPrismProtocolMock()
            locationBlockCalled = false

            let dispatcher = SearchInputDispatcher(actionSubscriber: AnySubscriber(mockActionSubscriber),
                                                   actionPrism: mockSearchActivityActionPrism,
                                                   locationUpdateRequestBlock: locationUpdateStub)
            stubInputViewModel = .dispatching(content: .stubValue(),
                                              dispatcher: IgnoredEquatable(dispatcher))
            mockInputViewModelBuilder = SearchInputViewModelBuilderProtocolMock()
            mockInputViewModelBuilder.buildDispatchingViewModelInputParamsCopyContentLocationUpdateRequestBlockReturnValue = stubInputViewModel

            mockChildBuilder = SearchLookupChildBuilderProtocolMock()
            mockChildBuilder.buildChildLoadStateAppCopyContentAppSkinLocationUpdateRequestBlockReturnValue = .progress(.stubValue())

            sut = SearchLookupViewModelBuilder(inputViewModelBuilder: mockInputViewModelBuilder,
                                               childBuilder: mockChildBuilder)
        }

        describe("buildViewModel()") {

            beforeEach {
                result = sut.buildViewModel(
                    searchActivityState: stubSearchActivityState,
                    appCopyContent: stubAppCopyContent,
                    appSkin: .stubValue()
                ) {
                    locationBlockCalled = true
                    return .success(.stubValue())
                }
            }

            it("calls mockInputViewModelBuilder with expected method and args") {
                let receivedArgs = mockInputViewModelBuilder.buildDispatchingViewModelInputParamsCopyContentLocationUpdateRequestBlockReceivedArguments
                expect(receivedArgs?.inputParams) == stubInputParams
                expect(receivedArgs?.copyContent) == stubAppCopyContent.searchInput

                expect(locationBlockCalled) == false
                _ = await receivedArgs?.locationUpdateRequestBlock()
                expect(locationBlockCalled) == true
            }

            it("calls mockChildBuilder with expected method and args") {
                let receivedArgs = mockChildBuilder.buildChildLoadStateAppCopyContentAppSkinLocationUpdateRequestBlockReceivedArguments
                expect(receivedArgs?.loadState) == stubSearchActivityState.loadState
                expect(receivedArgs?.appCopyContent) == stubAppCopyContent

                expect(locationBlockCalled) == false
                _ = await receivedArgs?.locationUpdateRequestBlock()
                expect(locationBlockCalled) == true
            }

            it("returns the expected value") {
                expect(result.searchInputViewModel) == stubInputViewModel
                expect(result.child) == .progress(.stubValue())
            }

        }

    }

}
