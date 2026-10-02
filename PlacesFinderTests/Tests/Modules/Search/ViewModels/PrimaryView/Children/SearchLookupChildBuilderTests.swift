//
//  SearchLookupChildBuilderTests.swift
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
import SharedTestComponents
import SwiftDux

// swiftlint:disable blanket_disable_command
// swiftlint:disable function_body_length
// swiftlint:disable implicitly_unwrapped_optional
// swiftlint:disable line_length
class SearchLookupChildBuilderTests: AsyncSpec {

    override class func spec() {

        let stubAppCopyContent = AppCopyContent.stubValue()
        let stubSearchParams = SearchParams.stubValue()
        let stubInstructionsProps = SearchInstructionsProps.stubValue()
        let stubNoResultsProps = SearchNoResultsFoundProps(messageViewProps: .stubValue())
        let stubRetryProps = SearchRetryProps(ctaViewProps: .stubValue())

        var mockActionSubscriber: MockSubscriber<Search.Action>!
        var mockSearchActivityActionPrism: SearchActivityActionPrismProtocolMock!

        var mockInstructionsPropsBuilder: SearchInstructionsPropsBuilderProtocolMock!
        var stubResultsProps: SearchResultsViewProps!
        var mockResultsPropsBuilder: SearchResultsViewPropsBuilderProtocolMock!
        var mockNoResultsFoundPropsBuilder: SearchNoResultsFoundPropsBuilderProtocolMock!
        var mockRetryPropsBuilder: SearchRetryPropsBuilderProtocolMock!

        var stubStartInitialRequestAction: Search.ActivityAction!

        var sut: SearchLookupChildBuilder!
        var result: SearchLookupChild!

        beforeEach {
            mockActionSubscriber = MockSubscriber()

            let mockPlaceLookupService = PlaceLookupServiceProtocolMock()
            let mockDependencies = Search.ActivityActionCreatorDependencies(
                placeLookupService: mockPlaceLookupService
            )
            stubStartInitialRequestAction = Search.ActivityAction.stubbedStartInitialRequestAction(dependencies: mockDependencies)

            mockSearchActivityActionPrism = SearchActivityActionPrismProtocolMock()
            mockSearchActivityActionPrism.initialRequestActionSearchParamsLocationUpdateRequestBlockReturnValue = stubStartInitialRequestAction

            mockInstructionsPropsBuilder = SearchInstructionsPropsBuilderProtocolMock()
            mockInstructionsPropsBuilder.buildPropsCopyContentColoringsReturnValue = stubInstructionsProps

            stubResultsProps = .stubValue(
                resultProps: NonEmptyArray(with: SearchResultProps.stubValue())
            )
            mockResultsPropsBuilder = SearchResultsViewPropsBuilderProtocolMock()
            mockResultsPropsBuilder.buildPropsSubmittedParamsAllEntitiesColoringsNumPagesReceivedTokenContainerResultsCopyContentLocationUpdateRequestBlockReturnValue
                = stubResultsProps

            mockNoResultsFoundPropsBuilder = SearchNoResultsFoundPropsBuilderProtocolMock()
            mockNoResultsFoundPropsBuilder.buildPropsCopyContentColoringsReturnValue = stubNoResultsProps

            mockRetryPropsBuilder = SearchRetryPropsBuilderProtocolMock()

            sut = SearchLookupChildBuilder(actionSubscriber: AnySubscriber(mockActionSubscriber),
                                           actionPrism: mockSearchActivityActionPrism,
                                           instructionsPropsBuilder: mockInstructionsPropsBuilder,
                                           resultsPropsBuilder: mockResultsPropsBuilder,
                                           noResultsFoundPropsBuilder: mockNoResultsFoundPropsBuilder,
                                           retryPropsBuilder: mockRetryPropsBuilder)
        }

        describe("buildChild()") {

            context("when loadState is .idle") {

                beforeEach {
                    result = sut.buildChild(
                        loadState: .idle,
                        appCopyContent: stubAppCopyContent,
                        appSkin: .stubValue()
                    ) {
                        .success(.stubValue())
                    }
                }

                it("calls mockInstructionsPropsBuilder with expected method and args") {
                    expect(mockInstructionsPropsBuilder.buildPropsCopyContentColoringsReceivedArguments?.copyContent)
                        == stubAppCopyContent.searchInstructions
                }

                it("returns a value of .instructions") {
                    expect(result) == .instructions(stubInstructionsProps)
                }

            }

            context("when loadState is .locationRequested") {

                beforeEach {
                    result = sut.buildChild(
                        loadState: .locationRequested(stubSearchParams),
                        appCopyContent: stubAppCopyContent,
                        appSkin: .stubValue()
                    ) {
                        .success(.stubValue())
                    }
                }

                it("returns a value of .progress") {
                    expect(result) == .progress(.stubValue())
                }

            }

            context("when loadState is .locationRequested") {

                beforeEach {
                    result = sut.buildChild(
                        loadState: .initialPageRequested(stubSearchParams),
                        appCopyContent: stubAppCopyContent,
                        appSkin: .stubValue()
                    ) {
                        .success(.stubValue())
                    }
                }

                it("returns a value of .progress") {
                    expect(result) == .progress(.stubValue())
                }

            }

            context("when loadState is .pagesReceived") {

                let stubEntities = NonEmptyArray(with: SearchEntityModel.stubValue())
                let tokenContainer = PlaceLookupTokenAttemptsContainer.stubValue()

                beforeEach {
                    result = sut.buildChild(
                        loadState: .pagesReceived(
                            params: stubSearchParams,
                            pageState: .success,
                            numPagesReceived: 1,
                            allEntities: stubEntities,
                            nextRequestToken: tokenContainer
                        ),
                        appCopyContent: stubAppCopyContent,
                        appSkin: .stubValue()
                    ) {
                        .success(.stubValue())
                    }
                }

                it("calls mockResultsPropsBuilder with expected method and args") {
                    let args =
                    mockResultsPropsBuilder.buildPropsSubmittedParamsAllEntitiesColoringsNumPagesReceivedTokenContainerResultsCopyContentLocationUpdateRequestBlockReceivedArguments
                    expect(args?.submittedParams) == stubSearchParams
                    expect(args?.allEntities) == stubEntities
                    expect(args?.tokenContainer) == tokenContainer
                    expect(args?.resultsCopyContent) == stubAppCopyContent.searchResults
                }

                it("returns a value of .results") {
                    expect(result) == .results(stubResultsProps)
                }

            }

            context("when loadState is .noResultsFound") {

                beforeEach {
                    result = sut.buildChild(
                        loadState: .noResultsFound(stubSearchParams),
                        appCopyContent: stubAppCopyContent,
                        appSkin: .stubValue()
                    ) {
                        .success(.stubValue())
                    }
                }

                it("calls mockNoResultsFoundPropsBuilder with expected method and args") {
                    expect(mockNoResultsFoundPropsBuilder.buildPropsCopyContentColoringsReceivedArguments?.copyContent) == stubAppCopyContent.searchNoResults
                }

                it("returns a value of .noResults") {
                    expect(result) == .noResults(stubNoResultsProps)
                }

            }

            context("when loadState is .failure") {

                var receivedCopyContent: SearchRetryCopyContent!
                var receivedCTABlock: SearchCTABlock!

                beforeEach {
                    mockRetryPropsBuilder.buildPropsCopyContentColoringsCtaBlockClosure = {
                        receivedCopyContent = $0
                        receivedCTABlock = $2
                        return stubRetryProps
                    }

                    result = sut.buildChild(
                        loadState: .failure(
                            stubSearchParams,
                            underlyingError: IgnoredEquatable(StubError.plainError)
                        ),
                        appCopyContent: stubAppCopyContent,
                        appSkin: .stubValue()
                    ) {
                        .success(.stubValue())
                    }
                }

                it("calls mockRetryPropsBuilder with expected method and args") {
                    expect(receivedCopyContent) == stubAppCopyContent.searchRetry
                }

                it("returns a value of .failure, containing expected values") {
                    expect(result) == .failure(stubRetryProps)
                }

                it("includes the Action returned by mockSearchActivityActionPrism") {
                    expect(mockActionSubscriber.receivedInputs.isEmpty) == true
                    receivedCTABlock()
                    expect(mockActionSubscriber.receivedInputs.first) == .searchActivity(stubStartInitialRequestAction)
                }

            }

        }

    }

}
// swiftlint:enable blanket_disable_command
