//
//  SearchDetailsViewContextBuilderTests.swift
//  PlacesFinderTests
//
//  Created by Justin Peckner.
//  Copyright © 2020 Justin Peckner. All rights reserved.
//

import Nimble
import Quick
import Shared
import SwiftDux

class SearchDetailsViewContextBuilderTests: QuickSpec {

    // swiftlint:disable function_body_length
    // swiftlint:disable implicitly_unwrapped_optional
    override func spec() {

        let stubAppCopyContent = AppCopyContent.stubValue()

        var mockStore: MockAppStore!
        var stubDetailsViewModel: SearchDetailsViewModel!
        var mockDetailsViewModelBuilder: SearchDetailsViewModelBuilderProtocolMock!

        var sut: SearchDetailsViewContextBuilder!
        var result: SearchDetailsViewContext!

        beforeEach {
            mockStore = MockAppStore()

            stubDetailsViewModel = SearchDetailsViewModel(placeName: "stubPlaceName",
                                                          sections: [.info([.basicInfo(.stubValue())])],
                                                          store: mockStore,
                                                          removeDetailedEntityAction: StubAction.genericAction)
            mockDetailsViewModelBuilder = SearchDetailsViewModelBuilderProtocolMock()
            mockDetailsViewModelBuilder.buildViewModelResultsCopyContentReturnValue = stubDetailsViewModel

            sut = SearchDetailsViewContextBuilder(detailsViewModelBuilder: mockDetailsViewModelBuilder)
        }

        describe("buildViewContext()") {

            context("when SearchState.detailedEntity is non-nil") {
                let stubEntity = SearchEntityModel.stubValue()
                let stubSearchState = SearchState(loadState: .idle,
                                                  inputParams: .stubValue(),
                                                  detailedEntity: stubEntity)

                beforeEach {
                    result = sut.buildViewContext(stubSearchState,
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

            context("else when SearchState.detailedEntity is non-nil") {
                let stubEntities = NonEmptyArray(with:
                    SearchEntityModel.stubValue(id: "stubID_0")
                ).appendedWith([
                    SearchEntityModel.stubValue(id: "stubID_1"),
                    SearchEntityModel.stubValue(id: "stubID_2"),
                ])
                let stubSearchState = SearchState(loadState: .pagesReceived(.stubValue(),
                                                                            pageState: .success,
                                                                            allEntities: stubEntities,
                                                                            nextRequestToken: nil),
                                                  inputParams: .stubValue(),
                                                  detailedEntity: nil)
                beforeEach {
                    result = sut.buildViewContext(stubSearchState,
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
                let stubSearchState = SearchState(loadState: .idle,
                                                  inputParams: .stubValue(),
                                                  detailedEntity: nil)
                beforeEach {
                    result = sut.buildViewContext(stubSearchState,
                                                  appCopyContent: stubAppCopyContent)
                }

                it("returns nil") {
                    expect(result).to(beNil())
                }
            }

        }

    }

}
