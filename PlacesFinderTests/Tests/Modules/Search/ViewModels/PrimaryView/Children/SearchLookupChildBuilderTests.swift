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

import Nimble
import Quick
import Shared
import SharedTestComponents
import SwiftDux

class SearchLookupChildBuilderTests: QuickSpec {

    private enum SearchActivityAction: Action {
        case initialRequest
    }

    // swiftlint:disable function_body_length
    // swiftlint:disable implicitly_unwrapped_optional
    // swiftlint:disable line_length
    override func spec() {

        let stubAppCopyContent = AppCopyContent.stubValue()
        let stubSearchParams = SearchParams.stubValue()
        let stubInstructionsViewModel = SearchInstructionsViewModel.stubValue()
        let stubNoResultsViewModel = SearchNoResultsFoundViewModel(messageViewModel: .stubValue())
        let stubRetryViewModel = SearchRetryViewModel(ctaViewModel: .stubValue())

        var mockStore: MockAppStore!
        var mockSearchActivityActionPrism: SearchActivityActionPrismProtocolMock!

        var mockInstructionsViewModelBuilder: SearchInstructionsViewModelBuilderProtocolMock!
        var stubResultsViewModel: SearchResultsViewModel!
        var mockResultsViewModelBuilder: SearchResultsViewModelBuilderProtocolMock!
        var mockNoResultsFoundViewModelBuilder: SearchNoResultsFoundViewModelBuilderProtocolMock!
        var mockRetryViewModelBuilder: SearchRetryViewModelBuilderProtocolMock!

        var sut: SearchLookupChildBuilder!
        var result: SearchLookupChild!

        beforeEach {
            mockStore = MockAppStore()

            mockSearchActivityActionPrism = SearchActivityActionPrismProtocolMock()
            mockSearchActivityActionPrism.initialRequestActionLocationUpdateRequestBlockReturnValue = SearchActivityAction.initialRequest

            mockInstructionsViewModelBuilder = SearchInstructionsViewModelBuilderProtocolMock()
            mockInstructionsViewModelBuilder.buildViewModelCopyContentReturnValue = stubInstructionsViewModel

            stubResultsViewModel = .stubValue(
                store: mockStore,
                resultViewModels: NonEmptyArray(with: SearchResultViewModel.stubValue(store: mockStore))
            )
            mockResultsViewModelBuilder = SearchResultsViewModelBuilderProtocolMock()
            mockResultsViewModelBuilder
                .buildViewModelSubmittedParamsAllEntitiesTokenContainerResultsCopyContentLocationUpdateRequestBlockReturnValue
                = stubResultsViewModel

            mockNoResultsFoundViewModelBuilder = SearchNoResultsFoundViewModelBuilderProtocolMock()
            mockNoResultsFoundViewModelBuilder.buildViewModelReturnValue = stubNoResultsViewModel

            mockRetryViewModelBuilder = SearchRetryViewModelBuilderProtocolMock()

            sut = SearchLookupChildBuilder(store: mockStore,
                                           actionPrism: mockSearchActivityActionPrism,
                                           instructionsViewModelBuilder: mockInstructionsViewModelBuilder,
                                           resultsViewModelBuilder: mockResultsViewModelBuilder,
                                           noResultsFoundViewModelBuilder: mockNoResultsFoundViewModelBuilder,
                                           retryViewModelBuilder: mockRetryViewModelBuilder)
        }

        describe("buildViewModel()") {

            context("when loadState is .idle") {

                beforeEach {
                    result = sut.buildChild(.idle,
                                            appCopyContent: stubAppCopyContent) { _ in }
                }

                it("calls mockInstructionsViewModelBuilder with expected method and args") {
                    expect(mockInstructionsViewModelBuilder.buildViewModelCopyContentReceivedCopyContent)
                        == stubAppCopyContent.searchInstructions
                }

                it("returns a value of .instructions") {
                    guard case let .instructions(viewModel) = result else {
                        fail("Unexpected value found: \(String(describing: result))")
                        return
                    }

                    expect(viewModel) == stubInstructionsViewModel
                }

            }

            context("when loadState is .locationRequested") {

                beforeEach {
                    result = sut.buildChild(.locationRequested(stubSearchParams),
                                            appCopyContent: stubAppCopyContent) { _ in }
                }

                it("returns a value of .progress") {
                    guard case .progress = result else {
                        fail("Unexpected value found: \(String(describing: result))")
                        return
                    }
                }

            }

            context("when loadState is .locationRequested") {

                beforeEach {
                    result = sut.buildChild(.initialPageRequested(stubSearchParams),
                                            appCopyContent: stubAppCopyContent) { _ in }
                }

                it("returns a value of .progress") {
                    guard case .progress = result else {
                        fail("Unexpected value found: \(String(describing: result))")
                        return
                    }
                }

            }

            context("when loadState is .pagesReceived") {

                let stubEntities = NonEmptyArray(with: SearchEntityModel.stubValue())
                let tokenContainer = PlaceLookupTokenAttemptsContainer.stubValue()

                beforeEach {
                    result = sut.buildChild(.pagesReceived(stubSearchParams,
                                                           pageState: .success,
                                                           allEntities: stubEntities,
                                                           nextRequestToken: tokenContainer),
                                            appCopyContent: stubAppCopyContent) { _ in }
                }

                it("calls mockResultsViewModelBuilder with expected method and args") {
                    let args =
                        mockResultsViewModelBuilder
                        .buildViewModelSubmittedParamsAllEntitiesTokenContainerResultsCopyContentLocationUpdateRequestBlockReceivedArguments
                    expect(args?.submittedParams) == stubSearchParams
                    expect(args?.allEntities) == stubEntities
                    expect(args?.tokenContainer) == tokenContainer
                    expect(args?.resultsCopyContent) == stubAppCopyContent.searchResults
                }

                it("returns a value of .results") {
                    guard case let .results(viewModel) = result else {
                        fail("Unexpected value found: \(String(describing: result))")
                        return
                    }

                    expect(viewModel) == stubResultsViewModel
                }

            }

            context("when loadState is .noResultsFound") {

                beforeEach {
                    result = sut.buildChild(.noResultsFound(stubSearchParams),
                                            appCopyContent: stubAppCopyContent) { _ in }
                }

                it("calls mockNoResultsFoundViewModelBuilder with expected method and args") {
                    expect(mockNoResultsFoundViewModelBuilder.buildViewModelReceivedCopyContent) == stubAppCopyContent.searchNoResults
                }

                it("returns a value of .noResults") {
                    guard case let .noResults(viewModel) = result else {
                        fail("Unexpected value found: \(String(describing: result))")
                        return
                    }

                    expect(viewModel) == stubNoResultsViewModel
                }

            }

            context("when loadState is .failure") {

                var receivedCopyContent: SearchRetryCopyContent!
                var receivedCTABlock: SearchCTABlock!

                beforeEach {
                    mockRetryViewModelBuilder.buildViewModelCtaBlockClosure = {
                        receivedCopyContent = $0
                        receivedCTABlock = $1
                        return stubRetryViewModel
                    }

                    result = sut.buildChild(.failure(stubSearchParams,
                                                     underlyingError: IgnoredEquatable(StubError.plainError)),
                                            appCopyContent: stubAppCopyContent) { _ in }
                }

                it("calls mockRetryViewModelBuilder with expected method and args") {
                    expect(receivedCopyContent) == stubAppCopyContent.searchRetry
                }

                it("returns a value of .failure, containing expected values") {
                    guard case let .failure(viewModel) = result else {
                        fail("Unexpected value found: \(String(describing: result))")
                        return
                    }

                    expect(viewModel) == stubRetryViewModel
                }

                it("includes the Action returned by mockSearchActivityActionPrism") {
                    expect(mockStore.dispatchedActions.isEmpty) == true
                    receivedCTABlock()
                    expect(mockStore.dispatchedActions.first as? SearchActivityAction) == .initialRequest
                }

            }

        }

    }

}
