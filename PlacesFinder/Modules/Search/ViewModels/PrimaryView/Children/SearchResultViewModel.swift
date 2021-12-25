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

struct SearchResultViewModel: Equatable {
    let cellModel: SearchResultCellModel
    private let store: IgnoredEquatable<DispatchingStoreProtocol>
    private let detailEntityAction: IgnoredEquatable<Action>

    init(cellModel: SearchResultCellModel,
         store: DispatchingStoreProtocol,
         detailEntityAction: Action) {
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

        return SearchResultViewModel(cellModel: cellModel,
                                     store: store,
                                     detailEntityAction: detailEntityAction)
    }

}
