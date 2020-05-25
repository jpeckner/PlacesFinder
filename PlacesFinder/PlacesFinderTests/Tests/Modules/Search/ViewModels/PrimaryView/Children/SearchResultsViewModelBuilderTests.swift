//
//  SearchResultsViewModelBuilderTests.swift
//  PlacesFinderTests
//
//  Created by Justin Peckner.
//  Copyright © 2020 Justin Peckner. All rights reserved.
//

import Nimble
import Quick
import Shared
import SwiftDuxTestComponents

class SearchResultsViewModelBuilderTests: QuickSpec {

    // swiftlint:disable function_body_length
    // swiftlint:disable implicitly_unwrapped_optional
    // swiftlint:disable line_length
    override func spec() {

        let stubSearchParams = SearchParams.stubValue()
        let stubEntities = NonEmptyArray(with:
            SearchEntityModel.stubValue(id: "stubID_0")
        ).appendedWith([
            SearchEntityModel.stubValue(id: "stubID_1"),
            SearchEntityModel.stubValue(id: "stubID_2"),
        ])
        let stubTokenContainer = PlaceLookupTokenAttemptsContainer.stubValue()
        let stubCopyContent = SearchResultsCopyContent.stubValue()

        var mockStore: MockAppStore!
        var mockResultViewModelBuilder: SearchResultViewModelBuilderProtocolMock!
        var mockSearchActionPrism: SearchActionPrismProtocolMock!

        var sut: SearchResultsViewModelBuilder!

        beforeEach {
            mockStore = MockAppStore()

            mockResultViewModelBuilder = SearchResultViewModelBuilderProtocolMock()
            mockResultViewModelBuilder.buildViewModelResultsCopyContentClosure = { entityModel, _ in
                let cellModel = SearchResultCellModel.stubValue(name: entityModel.name)
                return SearchResultViewModel.stubValue(id: entityModel.id,
                                                       store: mockStore,
                                                       cellModel: cellModel,
                                                       detailEntityAction: StubAction.genericAction)
            }

            mockSearchActionPrism = SearchActionPrismProtocolMock()
            mockSearchActionPrism.initialRequestActionLocationUpdateRequestBlockReturnValue =
                StubSearchAction.requestInitialPage
            mockSearchActionPrism.subsequentRequestActionAllEntitiesTokenContainerReturnValue =
                StubSearchAction.requestSubsequentPage

            sut = SearchResultsViewModelBuilder(store: mockStore,
                                                actionPrism: mockSearchActionPrism,
                                                resultViewModelBuilder: mockResultViewModelBuilder)
        }

        describe("buildViewModel()") {

            var locationBlockCalled: Bool!
            var result: SearchResultsViewModel!

            beforeEach {
                locationBlockCalled = false
                result = sut.buildViewModel(submittedParams: stubSearchParams,
                                            allEntities: stubEntities,
                                            tokenContainer: stubTokenContainer,
                                            resultsCopyContent: stubCopyContent) { _ in
                    locationBlockCalled = true
                }
            }

            it("calls mockSearchActionPrism to build refreshAction") {
                let initialRequestReceivedArgs = mockSearchActionPrism.initialRequestActionLocationUpdateRequestBlockReceivedArguments
                expect(initialRequestReceivedArgs?.searchParams) == stubSearchParams

                expect(locationBlockCalled) == false
                initialRequestReceivedArgs?.locationUpdateRequestBlock { _ in }
                expect(locationBlockCalled) == true
            }

            it("calls mockSearchActionPrism to build nextRequestAction") {
                let initialRequestReceivedArgs = mockSearchActionPrism.subsequentRequestActionAllEntitiesTokenContainerReceivedArguments
                expect(initialRequestReceivedArgs?.searchParams) == stubSearchParams
                expect(initialRequestReceivedArgs?.allEntities) == stubEntities
                expect(initialRequestReceivedArgs?.tokenContainer) == stubTokenContainer
            }

            it("inits a viewmodel with the entities as transformed by mockResultViewModelBuilder") {
                let expectedViewModels = stubEntities.withTransformation {
                    mockResultViewModelBuilder.buildViewModel($0,
                                                              resultsCopyContent: stubCopyContent)
                }

                expect(result.cellViewModelCount) == 3
                for idx in 0..<3 {
                    expect(result.cellViewModel(rowIndex: idx)) == expectedViewModels.value[idx].cellModel
                }
            }

            it("passes the expected action as refreshAction") {
                expect(mockStore.dispatchedActions.isEmpty) == true
                result.dispatchRefreshAction()
                expect(mockStore.dispatchedActions.first as? StubSearchAction) == .requestInitialPage
            }

            it("passes the expected action as nextRequestAction") {
                expect(mockStore.dispatchedActions.isEmpty) == true
                result.dispatchNextRequestAction()
                expect(mockStore.dispatchedActions.first as? StubSearchAction) == .requestSubsequentPage
            }

        }

    }

}
