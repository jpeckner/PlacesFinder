//
//  SearchResultsViewPropsBuilderTests.swift
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
import SwiftDuxTestComponents

// swiftlint:disable blanket_disable_command
// swiftlint:disable function_body_length
// swiftlint:disable implicitly_unwrapped_optional
// swiftlint:disable line_length
class SearchResultsViewPropsBuilderTests: QuickSpec {

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
        var mockDependencies: Search.ActivityActionCreatorDependencies!
        var stubInitialRequestAction: Search.ActivityAction!
        var stubSubsequentRequestAction: Search.ActivityAction!

        var mockResultPropsBuilder: SearchResultPropsBuilderProtocolMock!
        var mockSearchActivityActionPrism: SearchActivityActionPrismProtocolMock!

        var sut: SearchResultsViewPropsBuilder!

        beforeEach {
            mockResultPropsBuilder = SearchResultPropsBuilderProtocolMock()
            mockResultPropsBuilder.buildPropsModelResultsCopyContentColoringsClosure = { entityModel, _, _ in
                let cellProps = SearchResultCellProps.stubValue(name: entityModel.name)
                return SearchResultProps.stubValue(cellProps: cellProps,
                                                   detailEntityAction: .searchActivity(.detailedEntity(entityModel)))
            }

            mockPlaceLookupService = PlaceLookupServiceProtocolMock()
            mockDependencies = Search.ActivityActionCreatorDependencies(
                placeLookupService: mockPlaceLookupService
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

            sut = SearchResultsViewPropsBuilder(actionPrism: mockSearchActivityActionPrism,
                                                resultPropsBuilder: mockResultPropsBuilder)
        }

        describe("buildProps()") {

            var locationBlockCalled: Bool!
            var result: SearchResultsViewProps!

            beforeEach {
                locationBlockCalled = false
                result = sut.buildProps(submittedParams: stubSearchParams,
                                        allEntities: stubEntities,
                                        colorings: AppColorings.defaultColorings.searchResults,
                                        numPagesReceived: 1,
                                        tokenContainer: stubTokenContainer,
                                        resultsCopyContent: stubCopyContent) {
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

            it("inits props with the entities as transformed by mockResultPropsBuilder") {
                let expectedProps = stubEntities.withTransformation { model in
                    mockResultPropsBuilder.buildProps(model: model,
                                                      resultsCopyContent: stubCopyContent,
                                                      colorings: AppColorings.defaultColorings.searchResults)
                }

                expect(result.resultProps.value.count) == 3
                for idx in 0..<3 {
                    expect(result.resultProps.value[idx].cellProps) == expectedProps.value[idx].cellProps
                }
            }

            it("passes the expected action as refreshAction") {
                expect(result.refreshAction.value) == .searchActivity(stubInitialRequestAction)
            }

            it("passes the expected action as nextRequestAction") {
                let nextRequestAction = await result.nextRequestAction.value.consume()
                expect(nextRequestAction) == .searchActivity(stubSubsequentRequestAction)
            }

        }

    }

}
// swiftlint:enable blanket_disable_command
