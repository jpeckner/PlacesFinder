//
//  SearchResultViewModel.swift
//  PlacesFinder
//
//  Created by Justin Peckner.
//  Copyright © 2020 Justin Peckner. All rights reserved.
//

import Shared
import SwiftDux

struct SearchResultViewModel {
    let cellModel: SearchResultCellModel
    let detailEntityAction: Action
}

struct SearchResultsViewModel {
    let resultViewModels: NonEmptyArray<SearchResultViewModel>
}

extension SearchResultsViewModel {

    init(allEntities: NonEmptyArray<SearchEntityModel>,
         actionPrism: SearchDetailsActionPrismProtocol,
         copyFormatter: SearchCopyFormatterProtocol,
         resultsCopyContent: SearchResultsCopyContent) {
        self.resultViewModels = allEntities.withTransformation {
            let cellModel = SearchResultCellModel(model: $0,
                                                  copyFormatter: copyFormatter,
                                                  resultsCopyContent: resultsCopyContent)
            let detailEntityAction = actionPrism.detailEntityAction($0)

            return SearchResultViewModel(cellModel: cellModel,
                                         detailEntityAction: detailEntityAction)
        }
    }

}
