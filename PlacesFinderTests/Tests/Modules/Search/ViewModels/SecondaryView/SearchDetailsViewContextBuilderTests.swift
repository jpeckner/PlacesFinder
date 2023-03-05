//
//  SearchDetailsViewContextBuilderTests.swift
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
import SwiftDuxTestComponents

class SearchDetailsViewContextBuilderTests: QuickSpec {

    // swiftlint:disable function_body_length
    // swiftlint:disable implicitly_unwrapped_optional
    override func spec() {

        let stubAppCopyContent = AppCopyContent.stubValue()

        var mockActionSubscriber: MockSubscriber<Search.Action>!
        var stubDetailsViewModel: SearchDetailsViewModel!
        var mockDetailsViewModelBuilder: SearchDetailsViewModelBuilderProtocolMock!

        var sut: SearchDetailsViewContextBuilder!
        var result: SearchDetailsViewContext!

        beforeEach {
            mockActionSubscriber = MockSubscriber()

            stubDetailsViewModel = SearchDetailsViewModel(
                placeName: "stubPlaceName",
                sections: [.info([.basicInfo(.stubValue())])],
                actionSubscriber: AnySubscriber(mockActionSubscriber),
                removeDetailedEntityAction: .searchActivity(.removeDetailedEntity)
            )
            mockDetailsViewModelBuilder = SearchDetailsViewModelBuilderProtocolMock()
            mockDetailsViewModelBuilder.buildViewModelResultsCopyContentReturnValue = stubDetailsViewModel

            sut = SearchDetailsViewContextBuilder(detailsViewModelBuilder: mockDetailsViewModelBuilder)
        }

        describe("buildViewContext()") {

            context("when Search.ActivityState.detailedEntity is non-nil") {
                let stubEntity = SearchEntityModel.stubValue()
                let stubSearchActivityState = Search.ActivityState(loadState: .idle,
                                                                   inputParams: .stubValue(),
                                                                   detailedEntity: stubEntity)

                beforeEach {
                    result = sut.buildViewContext(stubSearchActivityState,
                                                  appCopyContent: stubAppCopyContent)
                }

                it("calls mockDetailsViewModelBuilder with expected method and args") {
                    let receivedArgs = mockDetailsViewModelBuilder.buildViewModelResultsCopyContentReceivedArguments
                    expect(receivedArgs?.entity) == stubEntity
                    expect(receivedArgs?.resultsCopyContent) == stubAppCopyContent.searchResults
                }

                it("returns .detailedEntity") {
                    expect(result) == .detailedEntity(stubDetailsViewModel)
                }
            }

            context("else when Search.ActivityState.detailedEntity is non-nil") {
                let stubEntities = NonEmptyArray(with:
                    SearchEntityModel.stubValue(id: "stubID_0")
                ).appendedWith([
                    SearchEntityModel.stubValue(id: "stubID_1"),
                    SearchEntityModel.stubValue(id: "stubID_2"),
                ])
                let stubSearchActivityState = Search.ActivityState(
                    loadState: .pagesReceived(params: .stubValue(),
                                              pageState: .success,
                                              numPagesReceived: 1,
                                              allEntities: stubEntities,
                                              nextRequestToken: nil),
                    inputParams: .stubValue(),
                    detailedEntity: nil
                )
                beforeEach {
                    result = sut.buildViewContext(stubSearchActivityState,
                                                  appCopyContent: stubAppCopyContent)
                }

                it("calls mockDetailsViewModelBuilder with expected method and args") {
                    let receivedArgs = mockDetailsViewModelBuilder.buildViewModelResultsCopyContentReceivedArguments
                    expect(receivedArgs?.entity) == stubEntities.first
                    expect(receivedArgs?.resultsCopyContent) == stubAppCopyContent.searchResults
                }

                it("returns .firstListedEntity") {
                    expect(result) == .firstListedEntity(stubDetailsViewModel)
                }
            }

            context("else") {
                let stubSearchActivityState = Search.ActivityState(
                    loadState: .idle,
                    inputParams: .stubValue(),
                    detailedEntity: nil
                )
                beforeEach {
                    result = sut.buildViewContext(stubSearchActivityState,
                                                  appCopyContent: stubAppCopyContent)
                }

                it("returns nil") {
                    expect(result).to(beNil())
                }
            }

        }

    }

}
