//
//  SearchLookupViewModelBuilderTests.swift
//  PlacesFinder
//
//  Created by Justin Peckner.
//  Copyright © 2020 Justin Peckner. All rights reserved.
//

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

            stubInputViewModel = SearchInputViewModel(content: .stubValue(),
                                                      store: mockStore,
                                                      actionPrism: mockSearchActionPrism,
                                                      locationUpdateRequestBlock: locationUpdateStub)
            mockInputViewModelBuilder = SearchInputViewModelBuilderProtocolMock()
            mockInputViewModelBuilder.buildViewModelCopyContentLocationUpdateRequestBlockReturnValue = stubInputViewModel

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
                let receivedArgs = mockInputViewModelBuilder.buildViewModelCopyContentLocationUpdateRequestBlockReceivedArguments
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
