//
//  SearchResultsViewModelTests.swift
//  PlacesFinderTests
//
//  Created by Justin Peckner.
//  Copyright © 2020 Justin Peckner. All rights reserved.
//

import Nimble
import Quick
import Shared
import SwiftDux

class SearchResultsViewModelTests: QuickSpec {

    private enum StubViewModelAction: Action, Equatable {
        case refreshAction
        case nextRequestAction
        case detailEntity(String)
    }

    // swiftlint:disable implicitly_unwrapped_optional
    // swiftlint:disable function_body_length
    override func spec() {

        var mockStore: MockAppStore!
        var stubResultViewModels: NonEmptyArray<SearchResultViewModel>!
        var result: SearchResultsViewModel!

        func buildViewModel(
            resultViewModels: NonEmptyArray<SearchResultViewModel>,
            nextRequestAction: Action? = StubViewModelAction.nextRequestAction
        ) -> SearchResultsViewModel {
            return SearchResultsViewModel(resultViewModels: resultViewModels,
                                          store: mockStore,
                                          refreshAction: StubViewModelAction.refreshAction,
                                          nextRequestAction: nextRequestAction)
        }

        beforeEach {
            mockStore = MockAppStore()

            stubResultViewModels = NonEmptyArray([0, 1, 2].map { idx in
                SearchResultViewModel.stubValue(
                    id: .stubValue("stubID_\(idx)"),
                    store: mockStore,
                    cellModel: SearchResultCellModel.stubValue(name: .stubValue("stubName_\(idx)")),
                    detailEntityAction: StubViewModelAction.detailEntity("\(idx)")
                )
            })
        }

        describe("cellViewModelCount") {

            it("returns the number of cell view-models") {
                result = buildViewModel(resultViewModels: stubResultViewModels)
                expect(result.cellViewModelCount) == 3

                result = buildViewModel(resultViewModels: stubResultViewModels.appendedWith([
                    SearchResultViewModel.stubValue(id: .stubValue("stubID_3"),
                                                    store: mockStore)
                ]))
                expect(result.cellViewModelCount) == 4

                result = buildViewModel(resultViewModels: stubResultViewModels.appendedWith([
                    SearchResultViewModel.stubValue(id: .stubValue("stubID_4"),
                                                    store: mockStore),
                    SearchResultViewModel.stubValue(id: .stubValue("stubID_5"),
                                                    store: mockStore)
                ]))
                expect(result.cellViewModelCount) == 5
            }

        }

        describe("cellViewModel(rowIndex:)") {

            beforeEach {
                result = buildViewModel(resultViewModels: stubResultViewModels)
            }

            it("returns the view-model at the specified index") {
                expect(result.cellViewModel(rowIndex: 2)) == stubResultViewModels.value[2].cellModel
            }

        }

        describe("hasNextRequestAction") {

            context("when nextRequestAction is not nil") {
                beforeEach {
                    result = buildViewModel(resultViewModels: stubResultViewModels,
                                            nextRequestAction: StubViewModelAction.nextRequestAction)
                }

                it("returns true") {
                    expect(result.hasNextRequestAction) == true
                }
            }

            context("else (when nextRequestAction is nil)") {
                beforeEach {
                    result = buildViewModel(resultViewModels: stubResultViewModels,
                                            nextRequestAction: nil)
                }

                it("returns false") {
                    expect(result.hasNextRequestAction) == false
                }
            }

        }

        describe("dispatchNextRequestAction()") {

            context("when nextRequestAction is not nil") {
                beforeEach {
                    result = buildViewModel(resultViewModels: stubResultViewModels,
                                            nextRequestAction: StubViewModelAction.nextRequestAction)
                    result.dispatchNextRequestAction()
                }

                it("dispatches the expected action") {
                    expect(mockStore.dispatchedNonAsyncActions.last as? StubViewModelAction) == .nextRequestAction
                }

                it("nils-out nextRequestAction") {
                    expect(result.hasNextRequestAction) == false
                }
            }

            context("when nextRequestAction is nil") {
                var verificationBlock: NoDispatchVerificationBlock!

                beforeEach {
                    result = buildViewModel(resultViewModels: stubResultViewModels,
                                            nextRequestAction: nil)

                    verificationBlock = self.verifyNoDispatches(from: mockStore) {
                        result.dispatchNextRequestAction()
                    }
                }

                it("does not dispatch an action") {
                    verificationBlock()
                }
            }

        }

        describe("dispatchRefreshAction()") {
            beforeEach {
                result = buildViewModel(resultViewModels: stubResultViewModels)
                result.dispatchRefreshAction()
            }

            it("dispatches the expected action") {
                expect(mockStore.dispatchedNonAsyncActions.last as? StubViewModelAction) == .refreshAction
            }
        }

        describe("dispatchDetailsAction()") {
            beforeEach {
                result = buildViewModel(resultViewModels: stubResultViewModels)
                result.dispatchDetailsAction(rowIndex: 2)
            }

            it("dispatches the expected action") {
                expect(mockStore.dispatchedNonAsyncActions.last as? StubViewModelAction) == .detailEntity("2")
            }
        }

    }

}
