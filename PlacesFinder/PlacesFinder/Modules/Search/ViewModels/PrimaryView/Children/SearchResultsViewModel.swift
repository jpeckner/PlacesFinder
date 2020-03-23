//
//  SearchResultViewModel.swift
//  PlacesFinder
//
//  Created by Justin Peckner.
//  Copyright © 2020 Justin Peckner. All rights reserved.
//

import Shared
import SwiftDux

struct SearchResultsViewModel {
    private let resultViewModels: NonEmptyArray<SearchResultViewModel>
    private let store: DispatchingStoreProtocol
    private let refreshAction: Action
    private var nextRequestAction: Action?
}

extension SearchResultsViewModel {

    init(allEntities: NonEmptyArray<SearchEntityModel>,
         store: DispatchingStoreProtocol,
         actionPrism: SearchDetailsActionPrismProtocol,
         copyFormatter: SearchCopyFormatterProtocol,
         resultsCopyContent: SearchResultsCopyContent,
         refreshAction: Action,
         nextRequestAction: Action?) {
        self.resultViewModels = allEntities.withTransformation {
            let cellModel = SearchResultCellModel(model: $0,
                                                  copyFormatter: copyFormatter,
                                                  resultsCopyContent: resultsCopyContent)
            let detailEntityAction = actionPrism.detailEntityAction($0)

            return SearchResultViewModel(cellModel: cellModel,
                                         detailEntityAction: detailEntityAction)
        }

        self.store = store
        self.refreshAction = refreshAction
        self.nextRequestAction = nextRequestAction
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

    func dispatchRefreshAction() {
        store.dispatch(refreshAction)
    }

    mutating func dispatchNextRequestAction() {
        guard let nextRequestAction = nextRequestAction else { return }

        store.dispatch(nextRequestAction)
        self.nextRequestAction = nil
    }

    func dispatchDetailsAction(rowIndex: Int) {
        let viewModel = resultViewModel(rowIndex: rowIndex)
        store.dispatch(viewModel.detailEntityAction)
    }

}

private extension SearchResultsViewModel {

    func resultViewModel(rowIndex: Int) -> SearchResultViewModel {
        return resultViewModels.value[rowIndex]
    }

}
