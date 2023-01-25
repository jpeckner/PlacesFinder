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

import Combine
import Nimble
import Quick
import Shared
import SwiftDux
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
        let stubPreviousResults = NonEmptyArray(with: SearchEntityModel.stubValue(name: "previousResult"))
        let stubTokenContainer = PlaceLookupTokenAttemptsContainer.stubValue()
        let stubCopyContent = SearchResultsCopyContent.stubValue()

        var mockPlaceLookupService: PlaceLookupServiceProtocolMock!
        var mockSearchEntityModelBuilder: SearchEntityModelBuilderProtocolMock!
        var mockDependencies: Search.ActivityActionCreatorDependencies!
        var stubInitialRequestAction: Search.ActivityAction!
        var stubSubsequentRequestAction: Search.ActivityAction!

        var mockActionSubscriber: MockSubscriber<Search.Action>!
        var mockResultViewModelBuilder: SearchResultViewModelBuilderProtocolMock!
        var mockSearchActivityActionPrism: SearchActivityActionPrismProtocolMock!

        var sut: SearchResultsViewModelBuilder!

        beforeEach {
            mockActionSubscriber = MockSubscriber()

            mockResultViewModelBuilder = SearchResultViewModelBuilderProtocolMock()
            mockResultViewModelBuilder.buildViewModelResultsCopyContentClosure = { entityModel, _ in
                let cellModel = SearchResultCellModel.stubValue(name: entityModel.name)
                return SearchResultViewModel.stubValue(actionSubscriber: AnySubscriber(mockActionSubscriber),
                                                       cellModel: cellModel,
                                                       detailEntityAction: .searchActivity(.detailedEntity(entityModel)))
            }

            mockPlaceLookupService = PlaceLookupServiceProtocolMock()
            mockSearchEntityModelBuilder = SearchEntityModelBuilderProtocolMock()
            mockDependencies = Search.ActivityActionCreatorDependencies(
                placeLookupService: mockPlaceLookupService,
                searchEntityModelBuilder: mockSearchEntityModelBuilder
            )

            stubInitialRequestAction = .startInitialRequest(
                dependencies: IgnoredEquatable(mockDependencies),
                searchParams: stubSearchParams,
                locationUpdateRequestBlock: IgnoredEquatable { _ in }
            )

            stubSubsequentRequestAction = .startSubsequentRequest(
                dependencies: IgnoredEquatable(mockDependencies),
                searchParams: stubSearchParams,
                previousResults: stubPreviousResults,
                tokenContainer: stubTokenContainer
            )

            mockSearchActivityActionPrism = SearchActivityActionPrismProtocolMock()
            mockSearchActivityActionPrism.initialRequestActionLocationUpdateRequestBlockReturnValue = stubInitialRequestAction
            mockSearchActivityActionPrism.subsequentRequestActionAllEntitiesTokenContainerReturnValue = stubSubsequentRequestAction

            sut = SearchResultsViewModelBuilder(actionPrism: mockSearchActivityActionPrism,
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
                                            resultsCopyContent: stubCopyContent,
                                            actionSubscriber: AnySubscriber(mockActionSubscriber)) { _ in
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
                expect(mockActionSubscriber.receivedInputs.isEmpty) == true
                result.dispatchRefreshAction()
                expect(mockActionSubscriber.receivedInputs.first) == .searchActivity(stubInitialRequestAction)
            }

            it("passes the expected action as nextRequestAction") {
                expect(mockActionSubscriber.receivedInputs.isEmpty) == true
                result.dispatchNextRequestAction()
                expect(mockActionSubscriber.receivedInputs.first) == .searchActivity(stubSubsequentRequestAction)
            }

        }

    }

}
