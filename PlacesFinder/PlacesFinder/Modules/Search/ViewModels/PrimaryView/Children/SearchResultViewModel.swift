//
//  SearchResultViewModel.swift
//  PlacesFinder
//
//  Created by Justin Peckner.
//  Copyright © 2020 Justin Peckner. All rights reserved.
//

import Shared
import SwiftDux

struct SearchResultViewModel: Equatable, Identifiable {
    let id: NonEmptyString
    let cellModel: SearchResultCellModel
    private let store: IgnoredEquatable<DispatchingStoreProtocol>
    private let detailEntityAction: IgnoredEquatable<Action>

    init(id: NonEmptyString,
         cellModel: SearchResultCellModel,
         store: DispatchingStoreProtocol,
         detailEntityAction: Action) {
        self.id = id
        self.cellModel = cellModel
        self.store = IgnoredEquatable(store)
        self.detailEntityAction = IgnoredEquatable(detailEntityAction)
    }
}

extension SearchResultViewModel {

    func dispatchDetailEntityAction() {
        store.value.dispatch(detailEntityAction.value)
    }

}

// MARK: SearchResultViewModelBuilder

protocol SearchResultViewModelBuilderProtocol: AutoMockable {
    func buildViewModel(_ model: SearchEntityModel,
                        resultsCopyContent: SearchResultsCopyContent) -> SearchResultViewModel
}

class SearchResultViewModelBuilder: SearchResultViewModelBuilderProtocol {

    private let store: DispatchingStoreProtocol
    private let actionPrism: SearchDetailsActionPrismProtocol
    private let copyFormatter: SearchCopyFormatterProtocol
    private let resultCellModelBuilder: SearchResultCellModelBuilderProtocol

    init(store: DispatchingStoreProtocol,
         actionPrism: SearchDetailsActionPrismProtocol,
         copyFormatter: SearchCopyFormatterProtocol,
         resultCellModelBuilder: SearchResultCellModelBuilderProtocol) {
        self.store = store
        self.actionPrism = actionPrism
        self.copyFormatter = copyFormatter
        self.resultCellModelBuilder = resultCellModelBuilder
    }

    func buildViewModel(_ model: SearchEntityModel,
                        resultsCopyContent: SearchResultsCopyContent) -> SearchResultViewModel {
        let cellModel = resultCellModelBuilder.buildViewModel(model,
                                                              resultsCopyContent: resultsCopyContent)
        let detailEntityAction = actionPrism.detailEntityAction(model)

        return SearchResultViewModel(id: model.id,
                                     cellModel: cellModel,
                                     store: store,
                                     detailEntityAction: detailEntityAction)
    }

}
