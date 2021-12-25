//
//  SearchInputDispatcherTests.swift
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

class SearchInputDispatcherTests: QuickSpec {

    private enum StubPrismAction: Action, Equatable {
        case initialRequest(SearchParams)
        case update(SearchBarEditEvent)
    }

    // swiftlint:disable implicitly_unwrapped_optional
    // swiftlint:disable line_length
    override func spec() {

        var mockStore: MockAppStore!
        var mockActionPrism: SearchActionPrismProtocolMock!

        var locationBlockCalled: Bool!
        var sut: SearchInputDispatcher!

        beforeEach {
            mockStore = MockAppStore()

            mockActionPrism = SearchActionPrismProtocolMock()
            mockActionPrism.updateEditingActionClosure = {
                StubPrismAction.update($0)
            }

            locationBlockCalled = false
            sut = SearchInputDispatcher(store: mockStore,
                                        actionPrism: mockActionPrism) { _ in
                locationBlockCalled = true
            }
        }

        describe("dispatchEditEvent()") {

            for editEvent in SearchBarEditEvent.allCases {

                context("when the edit action is \(editEvent)") {
                    beforeEach {
                        sut.dispatchEditEvent(editEvent)
                    }

                    it("calls the expected action prism method") {
                        expect(mockActionPrism.updateEditingActionReceivedEditEvent) == editEvent
                    }

                    it("dispatches the expected action") {
                        expect(mockStore.dispatchedActions.first as? StubPrismAction) == .update(editEvent)
                    }
                }

            }

        }

        describe("dispatchSearchParams()") {

            let stubParams = SearchParams.stubValue()

            beforeEach {
                mockActionPrism.initialRequestActionLocationUpdateRequestBlockClosure = { receivedSearchParams, _ in
                    StubPrismAction.initialRequest(receivedSearchParams)
                }

                sut.dispatchSearchParams(stubParams)
            }

            it("calls the action prism with expected method and args") {
                expect(mockActionPrism.initialRequestActionLocationUpdateRequestBlockReceivedArguments?.searchParams) == stubParams

                expect(locationBlockCalled) == false
                mockActionPrism.initialRequestActionLocationUpdateRequestBlockReceivedArguments?.locationUpdateRequestBlock { _ in }
                expect(locationBlockCalled) == true
            }

            it("dispatches the expected action") {
                expect(mockStore.dispatchedActions.first as? StubPrismAction) == .initialRequest(stubParams)
            }

        }

    }

}
