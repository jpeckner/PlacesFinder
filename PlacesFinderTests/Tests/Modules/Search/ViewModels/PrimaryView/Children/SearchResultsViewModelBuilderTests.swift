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

// swiftlint:disable blanket_disable_command
// swiftlint:disable function_body_length
// swiftlint:disable implicitly_unwrapped_optional
// swiftlint:disable line_length
class SearchResultsViewModelBuilderTests: QuickSpec {

    override func spec() {

        let stubSearchParams = SearchParams.stubValue()
        let stubEntities = NonEmptyArray(with:
            SearchEntityModel.stubValue(id: .stubValue("stubID_0"))
        ).appendedWith([
            SearchEntityModel.stubValue(id: .stubValue("stubID_1")),
            SearchEntityModel.stubValue(id: .stubValue("stubID_2")),
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
            mockResultViewModelBuilder.buildViewModelModelResultsCopyContentColoringsClosure = { entityModel, _, _ in
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
                locationUpdateRequestBlock: IgnoredEquatable { .success(.stubValue()) }
            )

            stubSubsequentRequestAction = .startSubsequentRequest(
                dependencies: IgnoredEquatable(mockDependencies),
                params: Search.ActivityAction.StartSubsequentRequestParams(
                    searchParams: stubSearchParams,
                    numPagesReceived: 1,
                    previousResults: stubPreviousResults,
                    tokenContainer: stubTokenContainer
                )
            )

            mockSearchActivityActionPrism = SearchActivityActionPrismProtocolMock()
            mockSearchActivityActionPrism.initialRequestActionSearchParamsLocationUpdateRequestBlockReturnValue = stubInitialRequestAction
            mockSearchActivityActionPrism.subsequentRequestActionSearchParamsAllEntitiesNumPagesReceivedTokenContainerReturnValue = stubSubsequentRequestAction

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
                                            colorings: AppColorings.defaultColorings.searchResults,
                                            numPagesReceived: 1,
                                            tokenContainer: stubTokenContainer,
                                            resultsCopyContent: stubCopyContent,
                                            actionSubscriber: AnySubscriber(mockActionSubscriber)) {
                    locationBlockCalled = true
                    return .success(.stubValue())
                }
            }

            it("calls mockSearchActivityActionPrism to build refreshAction") {
                let initialRequestReceivedArgs = mockSearchActivityActionPrism.initialRequestActionSearchParamsLocationUpdateRequestBlockReceivedArguments
                expect(initialRequestReceivedArgs?.searchParams) == stubSearchParams

                expect(locationBlockCalled) == false
                _ = await initialRequestReceivedArgs?.locationUpdateRequestBlock()
                expect(locationBlockCalled) == true
            }

            it("calls mockSearchActivityActionPrism to build nextRequestAction") {
                let initialRequestReceivedArgs = mockSearchActivityActionPrism.subsequentRequestActionSearchParamsAllEntitiesNumPagesReceivedTokenContainerReceivedArguments
                expect(initialRequestReceivedArgs?.searchParams) == stubSearchParams
                expect(initialRequestReceivedArgs?.allEntities) == stubEntities
                expect(initialRequestReceivedArgs?.tokenContainer) == stubTokenContainer
            }

            it("inits a viewmodel with the entities as transformed by mockResultViewModelBuilder") {
                let expectedViewModels = stubEntities.withTransformation { model in
                    mockResultViewModelBuilder.buildViewModel(model: model,
                                                              resultsCopyContent: stubCopyContent,
                                                              colorings: AppColorings.defaultColorings.searchResults)
                }

                expect(result.resultViewModels.value.count) == 3
                for idx in 0..<3 {
                    expect(result.resultViewModels.value[idx].cellModel) == expectedViewModels.value[idx].cellModel
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
// swiftlint:enable blanket_disable_command
