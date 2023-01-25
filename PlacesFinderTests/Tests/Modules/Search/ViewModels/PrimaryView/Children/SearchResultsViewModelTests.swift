//
//  SearchResultsViewModelTests.swift
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

class SearchResultsViewModelTests: QuickSpec {

    // swiftlint:disable implicitly_unwrapped_optional
    // swiftlint:disable function_body_length
    override func spec() {

        let stubbedRefreshAction = Search.ActivityAction.stubbedStartInitialRequestAction()
        let stubbedNextRequestAction = Search.ActivityAction.stubbedStartSubsequentRequestAction()

        var mockActionSubscriber: MockSubscriber<Search.Action>!
        var stubResultViewModels: NonEmptyArray<SearchResultViewModel>!
        var result: SearchResultsViewModel!

        func buildViewModel(
            resultViewModels: NonEmptyArray<SearchResultViewModel>,
            nextRequestAction: Search.Action? = .searchActivity(.stubbedStartSubsequentRequestAction())
        ) -> SearchResultsViewModel {
            return SearchResultsViewModel(resultViewModels: resultViewModels,
                                          actionSubscriber: AnySubscriber(mockActionSubscriber),
                                          refreshAction: .searchActivity(stubbedRefreshAction),
                                          nextRequestAction: nextRequestAction)
        }

        beforeEach {
            mockActionSubscriber = MockSubscriber()

            stubResultViewModels = NonEmptyArray([0, 1, 2].map { idx in
                SearchResultViewModel.stubValue(
                    actionSubscriber: AnySubscriber(mockActionSubscriber),
                    cellModel: SearchResultCellModel.stubValue(name: .stubValue("stubName_\(idx)")),
                    detailEntityAction: .searchActivity(.detailedEntity(SearchEntityModel.stubValue(id: "\(idx)")))
                )
            })
        }

        describe("cellViewModelCount") {

            it("returns the number of cell view-models") {
                result = buildViewModel(resultViewModels: stubResultViewModels)
                expect(result.cellViewModelCount) == 3

                result = buildViewModel(resultViewModels: stubResultViewModels.appendedWith([
                    SearchResultViewModel.stubValue(actionSubscriber: AnySubscriber(mockActionSubscriber))
                ]))
                expect(result.cellViewModelCount) == 4

                result = buildViewModel(resultViewModels: stubResultViewModels.appendedWith([
                    SearchResultViewModel.stubValue(actionSubscriber: AnySubscriber(mockActionSubscriber)),
                    SearchResultViewModel.stubValue(actionSubscriber: AnySubscriber(mockActionSubscriber))
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
                                            nextRequestAction: .searchActivity(.stubbedStartInitialRequestAction()))
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
                                            nextRequestAction: .searchActivity(stubbedNextRequestAction))
                    result.dispatchNextRequestAction()
                }

                it("dispatches the expected action") {
                    expect(mockActionSubscriber.receivedInputs.last) == .searchActivity(stubbedNextRequestAction)
                }

                it("nils-out nextRequestAction") {
                    expect(result.hasNextRequestAction) == false
                }
            }

            context("when nextRequestAction is nil") {
                beforeEach {
                    result = buildViewModel(resultViewModels: stubResultViewModels,
                                            nextRequestAction: nil)

                    result.dispatchNextRequestAction()
                }

                it("does not dispatch an action") {
                    expect(mockActionSubscriber.receivedInputs.isEmpty) == true
                }
            }

        }

        describe("dispatchRefreshAction()") {
            beforeEach {
                result = buildViewModel(resultViewModels: stubResultViewModels)
                result.dispatchRefreshAction()
            }

            it("dispatches the expected action") {
                expect(mockActionSubscriber.receivedInputs.last) == .searchActivity(stubbedRefreshAction)
            }
        }

        describe("dispatchDetailsAction()") {
            beforeEach {
                result = buildViewModel(resultViewModels: stubResultViewModels)
                result.dispatchDetailsAction(rowIndex: 2)
            }

            it("dispatches the expected action") {
                expect(mockActionSubscriber.receivedInputs.last) == .searchActivity(.detailedEntity(.stubValue()))
            }
        }

    }

}
