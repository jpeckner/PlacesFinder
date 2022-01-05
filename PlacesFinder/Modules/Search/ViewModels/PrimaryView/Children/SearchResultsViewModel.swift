//
//  SearchResultViewModel.swift
//  PlacesFinder
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

import Shared
import SwiftDux

struct SearchResultsViewModel: Equatable {
    private let resultViewModels: NonEmptyArray<SearchResultViewModel>
    private let store: IgnoredEquatable<DispatchingStoreProtocol>
    private let refreshAction: IgnoredEquatable<Action>
    private var nextRequestAction: IgnoredEquatable<Action>?

    init(resultViewModels: NonEmptyArray<SearchResultViewModel>,
         store: DispatchingStoreProtocol,
         refreshAction: Action,
         nextRequestAction: Action?) {
        self.resultViewModels = resultViewModels
        self.store = IgnoredEquatable(store)
        self.refreshAction = IgnoredEquatable(refreshAction)
        self.nextRequestAction = nextRequestAction.map { IgnoredEquatable($0) }
    }
}

extension SearchResultsViewModel {

    var cellViewModelCount: Int {
        return resultViewModels.value.count
    }

    func cellViewModel(rowIndex: Int) -> SearchResultCellModel {
        return resultViewModel(rowIndex: rowIndex).cellModel
    }

}

extension SearchResultsViewModel {

    var hasNextRequestAction: Bool {
        return nextRequestAction != nil
    }

    mutating func dispatchNextRequestAction() {
        guard let nextRequestAction = nextRequestAction else { return }

        store.value.dispatch(nextRequestAction.value)
        self.nextRequestAction = nil
    }

    func dispatchRefreshAction() {
        store.value.dispatch(refreshAction.value)
    }

    func dispatchDetailsAction(rowIndex: Int) {
        let viewModel = resultViewModel(rowIndex: rowIndex)
        viewModel.dispatchDetailEntityAction()
    }

}

private extension SearchResultsViewModel {

    func resultViewModel(rowIndex: Int) -> SearchResultViewModel {
        return resultViewModels.value[rowIndex]
    }

}

// MARK: SearchResultsViewModelBuilder

protocol SearchResultsViewModelBuilderProtocol: AutoMockable {
    func buildViewModel(submittedParams: SearchParams,
                        allEntities: NonEmptyArray<SearchEntityModel>,
                        tokenContainer: PlaceLookupTokenAttemptsContainer?,
                        resultsCopyContent: SearchResultsCopyContent,
                        locationUpdateRequestBlock: @escaping LocationUpdateRequestBlock) -> SearchResultsViewModel
}

class SearchResultsViewModelBuilder: SearchResultsViewModelBuilderProtocol {

    private let store: DispatchingStoreProtocol
    private let actionPrism: SearchActionPrismProtocol
    private let resultViewModelBuilder: SearchResultViewModelBuilderProtocol

    init(store: DispatchingStoreProtocol,
         actionPrism: SearchActionPrismProtocol,
         resultViewModelBuilder: SearchResultViewModelBuilderProtocol) {
        self.store = store
        self.actionPrism = actionPrism
        self.resultViewModelBuilder = resultViewModelBuilder
    }

    func buildViewModel(submittedParams: SearchParams,
                        allEntities: NonEmptyArray<SearchEntityModel>,
                        tokenContainer: PlaceLookupTokenAttemptsContainer?,
                        resultsCopyContent: SearchResultsCopyContent,
                        locationUpdateRequestBlock: @escaping LocationUpdateRequestBlock) -> SearchResultsViewModel {
        let resultViewModels: NonEmptyArray<SearchResultViewModel> = allEntities.withTransformation {
            resultViewModelBuilder.buildViewModel($0,
                                                  resultsCopyContent: resultsCopyContent)
        }

        let refreshAction = actionPrism.initialRequestAction(submittedParams,
                                                             locationUpdateRequestBlock: locationUpdateRequestBlock)

        let nextRequestAction = tokenContainer.flatMap {
            try? actionPrism.subsequentRequestAction(submittedParams,
                                                     allEntities: allEntities,
                                                     tokenContainer: $0)
        }

        return SearchResultsViewModel(resultViewModels: resultViewModels,
                                      store: store,
                                      refreshAction: refreshAction,
                                      nextRequestAction: nextRequestAction)
    }

}