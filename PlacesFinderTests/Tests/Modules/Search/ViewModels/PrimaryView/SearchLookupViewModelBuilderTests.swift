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

import Nimble
import Quick
import Shared

class SearchLookupViewModelBuilderTests: QuickSpec {

    // swiftlint:disable function_body_length
    // swiftlint:disable implicitly_unwrapped_optional
    // swiftlint:disable line_length
    override func spec() {

        let stubAppCopyContent = AppCopyContent.stubValue()
        let stubInputParams = SearchInputParams.stubValue()
        let stubSearchState = SearchState(loadState: .idle,
                                          inputParams: stubInputParams,
                                          detailedEntity: .stubValue())

        var mockStore: MockAppStore!
        var mockSearchActionPrism: SearchActionPrismProtocolMock!
        var stubInputViewModel: SearchInputViewModel!
        var mockInputViewModelBuilder: SearchInputViewModelBuilderProtocolMock!
        var mockChildBuilder: SearchLookupChildBuilderProtocolMock!

        var locationBlockCalled: Bool!
        var sut: SearchLookupViewModelBuilder!
        var result: SearchLookupViewModel!

        func locationUpdateStub(block: @escaping (LocationRequestResult) -> Void) {
            locationBlockCalled = true
        }

        beforeEach {
            mockStore = MockAppStore()
            mockSearchActionPrism = SearchActionPrismProtocolMock()
            locationBlockCalled = false

            let dispatcher = SearchInputDispatcher(store: mockStore,
                                                   actionPrism: mockSearchActionPrism,
                                                   locationUpdateRequestBlock: locationUpdateStub)
            stubInputViewModel = .dispatching(content: .stubValue(),
                                              dispatcher: dispatcher)
            mockInputViewModelBuilder = SearchInputViewModelBuilderProtocolMock()
            mockInputViewModelBuilder.buildDispatchingViewModelCopyContentLocationUpdateRequestBlockReturnValue = stubInputViewModel

            mockChildBuilder = SearchLookupChildBuilderProtocolMock()
            mockChildBuilder.buildChildAppCopyContentLocationUpdateRequestBlockReturnValue = .progress

            sut = SearchLookupViewModelBuilder(store: mockStore,
                                               actionPrism: mockSearchActionPrism,
                                               inputViewModelBuilder: mockInputViewModelBuilder,
                                               childBuilder: mockChildBuilder)
        }

        describe("buildViewModel()") {

            beforeEach {
                result = sut.buildViewModel(stubSearchState,
                                            appCopyContent: stubAppCopyContent) { _ in
                    locationBlockCalled = true
                }
            }

            it("calls mockInputViewModelBuilder with expected method and args") {
                let receivedArgs = mockInputViewModelBuilder.buildDispatchingViewModelCopyContentLocationUpdateRequestBlockReceivedArguments
                expect(receivedArgs?.inputParams) == stubInputParams
                expect(receivedArgs?.copyContent) == stubAppCopyContent.searchInput

                expect(locationBlockCalled) == false
                receivedArgs?.locationUpdateRequestBlock { _ in }
                expect(locationBlockCalled) == true
            }

            it("calls mockChildBuilder with expected method and args") {
                let receivedArgs = mockChildBuilder.buildChildAppCopyContentLocationUpdateRequestBlockReceivedArguments
                expect(receivedArgs?.loadState) == stubSearchState.loadState
                expect(receivedArgs?.appCopyContent) == stubAppCopyContent

                expect(locationBlockCalled) == false
                receivedArgs?.locationUpdateRequestBlock { _ in }
                expect(locationBlockCalled) == true
            }

            it("returns the expected value") {
                expect(result.searchInputViewModel) == stubInputViewModel
                expect(result.child) == .progress
            }

        }

    }

}