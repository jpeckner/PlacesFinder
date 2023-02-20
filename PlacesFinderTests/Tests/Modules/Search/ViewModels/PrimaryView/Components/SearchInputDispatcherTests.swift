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

import Combine
import Nimble
import Quick
import Shared
import SwiftDux

class SearchInputDispatcherTests: QuickSpec {

    // swiftlint:disable implicitly_unwrapped_optional
    // swiftlint:disable line_length
    override func spec() {

        var mockActionSubscriber: MockSubscriber<Search.Action>!
        var mockActionPrism: SearchActivityActionPrismProtocolMock!

        var locationBlockCalled: Bool!
        var sut: SearchInputDispatcher!

        beforeEach {
            mockActionSubscriber = MockSubscriber()

            mockActionPrism = SearchActivityActionPrismProtocolMock()
            mockActionPrism.updateEditingActionClosure = { editEvent in .updateInputEditing(editEvent) }

            locationBlockCalled = false
            sut = SearchInputDispatcher(actionSubscriber: AnySubscriber(mockActionSubscriber),
                                        actionPrism: mockActionPrism) {
                locationBlockCalled = true
                return .success(.stubValue())
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
                        expect(mockActionSubscriber.receivedInputs.first) == .searchActivity(.updateInputEditing(editEvent))
                    }
                }

            }

        }

        describe("dispatchSearchParams()") {

            let stubParams = SearchParams.stubValue()

            beforeEach {
                mockActionPrism.initialRequestActionLocationUpdateRequestBlockClosure = { receivedSearchParams, _ in
                    .initialPageRequested(receivedSearchParams)
                }

                sut.dispatchSearchParams(stubParams)
            }

            it("calls the action prism with expected method and args") {
                expect(mockActionPrism.initialRequestActionLocationUpdateRequestBlockReceivedArguments?.searchParams) == stubParams

                expect(locationBlockCalled) == false
                _ = await mockActionPrism.initialRequestActionLocationUpdateRequestBlockReceivedArguments?
                    .locationUpdateRequestBlock()
                expect(locationBlockCalled) == true
            }

            it("dispatches the expected action") {
                expect(mockActionSubscriber.receivedInputs.first) == .searchActivity(.initialPageRequested(stubParams))
            }

        }

    }

}
