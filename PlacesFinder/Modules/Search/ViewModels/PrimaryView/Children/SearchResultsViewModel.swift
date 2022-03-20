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

import Combine
import Shared
import SwiftDux

struct SearchResultsViewModel: Equatable {
    private let resultViewModels: NonEmptyArray<SearchResultViewModel>
    private let actionSubscriber: IgnoredEquatable<AnySubscriber<AppAction, Never>>
    private let refreshAction: IgnoredEquatable<AppAction>
    private var nextRequestAction: IgnoredEquatable<AppAction>?

    init(resultViewModels: NonEmptyArray<SearchResultViewModel>,
         actionSubscriber: AnySubscriber<AppAction, Never>,
         refreshAction: AppAction,
         nextRequestAction: AppAction?) {
        self.resultViewModels = resultViewModels
        self.actionSubscriber = IgnoredEquatable(actionSubscriber)
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

        _ = actionSubscriber.value.receive(nextRequestAction.value)
        self.nextRequestAction = nil
    }

    func dispatchRefreshAction() {
        _ = actionSubscriber.value.receive(refreshAction.value)
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
    // swiftlint:disable:next function_parameter_count
    func buildViewModel(submittedParams: SearchParams,
                        allEntities: NonEmptyArray<SearchEntityModel>,
                        tokenContainer: PlaceLookupTokenAttemptsContainer?,
                        resultsCopyContent: SearchResultsCopyContent,
                        actionSubscriber: AnySubscriber<AppAction, Never>,
                        locationUpdateRequestBlock: @escaping LocationUpdateRequestBlock) -> SearchResultsViewModel
}

class SearchResultsViewModelBuilder: SearchResultsViewModelBuilderProtocol {

    private let actionPrism: SearchActivityActionPrismProtocol
    private let resultViewModelBuilder: SearchResultViewModelBuilderProtocol

    init(actionPrism: SearchActivityActionPrismProtocol,
         resultViewModelBuilder: SearchResultViewModelBuilderProtocol) {
        self.actionPrism = actionPrism
        self.resultViewModelBuilder = resultViewModelBuilder
    }

    // swiftlint:disable:next function_parameter_count
    func buildViewModel(submittedParams: SearchParams,
                        allEntities: NonEmptyArray<SearchEntityModel>,
                        tokenContainer: PlaceLookupTokenAttemptsContainer?,
                        resultsCopyContent: SearchResultsCopyContent,
                        actionSubscriber: AnySubscriber<AppAction, Never>,
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
                                      actionSubscriber: actionSubscriber,
                                      refreshAction: refreshAction,
                                      nextRequestAction: nextRequestAction)
    }

}
