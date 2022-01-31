//
//  SearchResultsViewModelBuilderTests.swift
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
        var mockSearchActivityActionPrism: SearchActivityActionPrismProtocolMock!

        var sut: SearchResultsViewModelBuilder!

        beforeEach {
            mockStore = MockAppStore()

            mockResultViewModelBuilder = SearchResultViewModelBuilderProtocolMock()
            mockResultViewModelBuilder.buildViewModelResultsCopyContentClosure = { entityModel, _ in
                let cellModel = SearchResultCellModel.stubValue(name: entityModel.name)
                return SearchResultViewModel.stubValue(store: mockStore,
                                                       cellModel: cellModel,
                                                       detailEntityAction: StubAction.genericAction)
            }

            mockSearchActivityActionPrism = SearchActivityActionPrismProtocolMock()
            mockSearchActivityActionPrism.initialRequestActionLocationUpdateRequestBlockReturnValue =
                StubSearchActivityAction.requestInitialPage
            mockSearchActivityActionPrism.subsequentRequestActionAllEntitiesTokenContainerReturnValue =
                StubSearchActivityAction.requestSubsequentPage

            sut = SearchResultsViewModelBuilder(store: mockStore,
                                                actionPrism: mockSearchActivityActionPrism,
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

            it("calls mockSearchActivityActionPrism to build refreshAction") {
                let initialRequestReceivedArgs = mockSearchActivityActionPrism.initialRequestActionLocationUpdateRequestBlockReceivedArguments
                expect(initialRequestReceivedArgs?.searchParams) == stubSearchParams

                expect(locationBlockCalled) == false
                initialRequestReceivedArgs?.locationUpdateRequestBlock { _ in }
                expect(locationBlockCalled) == true
            }

            it("calls mockSearchActivityActionPrism to build nextRequestAction") {
                let initialRequestReceivedArgs = mockSearchActivityActionPrism.subsequentRequestActionAllEntitiesTokenContainerReceivedArguments
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
                expect(mockStore.dispatchedActions.first as? StubSearchActivityAction) == .requestInitialPage
            }

            it("passes the expected action as nextRequestAction") {
                expect(mockStore.dispatchedActions.isEmpty) == true
                result.dispatchNextRequestAction()
                expect(mockStore.dispatchedActions.first as? StubSearchActivityAction) == .requestSubsequentPage
            }

        }

    }

}
