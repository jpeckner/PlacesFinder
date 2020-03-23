//
//  SearchResultsViewModelTests.swift
//  PlacesFinder
//
//  Created by Justin Peckner.
//  Copyright © 2020 Justin Peckner. All rights reserved.
//

import Nimble
#if DEBUG
@testable import PlacesFinder
#endif
import Quick
import Shared
import SwiftDux

class SearchResultsViewModelTests: QuickSpec {

    private enum StubViewModelAction: Action, Equatable {
        case refreshAction
        case nextRequestAction
        case detailEntity(SearchEntityModel)
    }

    // swiftlint:disable implicitly_unwrapped_optional
    // swiftlint:disable function_body_length
    override func spec() {

        let stubEntity = SearchEntityModel.stubValue()
        let stubEntities = NonEmptyArray(with:
            SearchEntityModel.stubValue(id: "stubID_0")
        ).appendedWith([
            SearchEntityModel.stubValue(id: "stubID_1"),
            SearchEntityModel.stubValue(id: "stubID_2"),
        ])

        let stubCopyContent = SearchResultsCopyContent.stubValue()

        var mockStore: MockAppStore!
        var mockSearchActionPrism: SearchActionPrismProtocolMock!
        var mockFormatter: SearchCopyFormatterProtocolMock!

        var viewModel: SearchResultsViewModel!

        func buildViewModel(
            allEntities: NonEmptyArray<SearchEntityModel>,
            nextRequestAction: Action? = StubViewModelAction.nextRequestAction
        ) -> SearchResultsViewModel {
            return SearchResultsViewModel(allEntities: allEntities,
                                          store: mockStore,
                                          actionPrism: mockSearchActionPrism,
                                          copyFormatter: mockFormatter,
                                          resultsCopyContent: stubCopyContent,
                                          refreshAction: StubViewModelAction.refreshAction,
                                          nextRequestAction: nextRequestAction)
        }

        beforeEach {
            mockStore = MockAppStore()

            mockSearchActionPrism = SearchActionPrismProtocolMock()
            mockSearchActionPrism.detailEntityActionClosure = { StubViewModelAction.detailEntity($0) }

            mockFormatter = SearchCopyFormatterProtocolMock()
            mockFormatter.formatPricingPricingReturnValue = "formatPricingPricingReturnValue"
        }

        describe("cellViewModelCount") {

            it("returns the number of cell view-models") {
                viewModel = buildViewModel(allEntities: stubEntities)
                expect(viewModel.cellViewModelCount) == 3

                viewModel = buildViewModel(allEntities: stubEntities.appendedWith([stubEntity]))
                expect(viewModel.cellViewModelCount) == 4

                viewModel = buildViewModel(allEntities: stubEntities.appendedWith([stubEntity, stubEntity]))
                expect(viewModel.cellViewModelCount) == 5
            }

        }

        describe("cellViewModel(rowIndex:)") {

            beforeEach {
                viewModel = buildViewModel(allEntities: stubEntities)
            }

            it("returns the view-model at the specified index") {
                expect(viewModel.cellViewModel(rowIndex: 2)) == SearchResultCellModel(
                    model: stubEntities.value[2],
                    copyFormatter: mockFormatter,
                    resultsCopyContent: stubCopyContent
                )
            }

        }

        describe("hasNextRequestAction") {

            context("when nextRequestAction is not nil") {
                beforeEach {
                    viewModel = buildViewModel(allEntities: stubEntities,
                                               nextRequestAction: StubViewModelAction.nextRequestAction)
                }

                it("returns true") {
                    expect(viewModel.hasNextRequestAction) == true
                }
            }

            context("else (when nextRequestAction is nil)") {
                beforeEach {
                    viewModel = buildViewModel(allEntities: stubEntities,
                                               nextRequestAction: nil)
                }

                it("returns false") {
                    expect(viewModel.hasNextRequestAction) == false
                }
            }

        }

        describe("dispatchRefreshAction()") {
            beforeEach {
                viewModel = buildViewModel(allEntities: stubEntities)
                viewModel.dispatchRefreshAction()
            }

            it("dispatches the expected action") {
                expect(mockStore.dispatchedNonAsyncActions.last as? StubViewModelAction) == .refreshAction
            }
        }

        describe("dispatchNextRequestAction()") {

            context("when nextRequestAction is not nil") {
                beforeEach {
                    viewModel = buildViewModel(allEntities: stubEntities,
                                               nextRequestAction: StubViewModelAction.nextRequestAction)
                    viewModel.dispatchNextRequestAction()
                }

                it("dispatches the expected action") {
                    expect(mockStore.dispatchedNonAsyncActions.last as? StubViewModelAction) == .nextRequestAction
                }

                it("nils-out nextRequestAction") {
                    expect(viewModel.hasNextRequestAction) == false
                }
            }

            context("when nextRequestAction is nil") {
                var verificationBlock: NoDispatchVerificationBlock!

                beforeEach {
                    viewModel = buildViewModel(allEntities: stubEntities,
                                               nextRequestAction: nil)

                    verificationBlock = self.verifyNoDispatches(from: mockStore) {
                        viewModel.dispatchNextRequestAction()
                    }
                }

                it("does not dispatch an action") {
                    verificationBlock()
                }
            }

        }

        describe("dispatchDetailsAction()") {
            beforeEach {
                viewModel = buildViewModel(allEntities: stubEntities)
                viewModel.dispatchDetailsAction(rowIndex: 2)
            }

            it("dispatches the expected action") {
                expect(mockStore.dispatchedNonAsyncActions.last as? StubViewModelAction)
                    == .detailEntity(stubEntities.value[2])
            }
        }

    }

}
