//
//  SearchInputViewModelTests.swift
//  PlacesFinder
//
//  Created by Justin Peckner.
//  Copyright © 2020 Justin Peckner. All rights reserved.
//

import Nimble
#if DEBUG
@testable import PlacesFinder
#endif
import Quick
import SwiftDux

class SearchInputViewModelTests: QuickSpec {

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
        var sut: SearchInputViewModel!

        beforeEach {
            mockStore = MockAppStore()

            mockActionPrism = SearchActionPrismProtocolMock()
            mockActionPrism.updateEditingActionClosure = {
                StubPrismAction.update($0)
            }

            locationBlockCalled = false
            sut = SearchInputViewModel(content: SearchInputContentViewModel.stubValue(),
                                       store: mockStore,
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
