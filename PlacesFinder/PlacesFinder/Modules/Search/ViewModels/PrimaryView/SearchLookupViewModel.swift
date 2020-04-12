//
//  SearchLookupViewModel.swift
//  PlacesFinder
//
//  Created by Justin Peckner.
//  Copyright © 2020 Justin Peckner. All rights reserved.
//

import Foundation
import Shared
import SwiftDux

struct SearchLookupViewModel: Equatable {
    let searchInputViewModel: SearchInputViewModel
    let child: SearchLookupChild
}

protocol SearchLookupViewModelBuilderProtocol: AutoMockable {
    func buildViewModel(_ searchState: SearchState,
                        appCopyContent: AppCopyContent,
                        locationUpdateRequestBlock: @escaping LocationUpdateRequestBlock) -> SearchLookupViewModel
}

class SearchLookupViewModelBuilder: SearchLookupViewModelBuilderProtocol {

    private let store: DispatchingStoreProtocol
    private let actionPrism: SearchActionPrismProtocol
    private let inputViewModelBuilder: SearchInputViewModelBuilderProtocol
    private let childBuilder: SearchLookupChildBuilderProtocol

    init(store: DispatchingStoreProtocol,
         actionPrism: SearchActionPrismProtocol,
         inputViewModelBuilder: SearchInputViewModelBuilderProtocol,
         childBuilder: SearchLookupChildBuilderProtocol) {
        self.store = store
        self.actionPrism = actionPrism
        self.inputViewModelBuilder = inputViewModelBuilder
        self.childBuilder = childBuilder
    }

    func buildViewModel(_ searchState: SearchState,
                        appCopyContent: AppCopyContent,
                        locationUpdateRequestBlock: @escaping LocationUpdateRequestBlock) -> SearchLookupViewModel {
        let searchInputViewModel = inputViewModelBuilder.buildViewModel(
            searchState.inputParams,
            copyContent: appCopyContent.searchInput,
            locationUpdateRequestBlock: locationUpdateRequestBlock
        )

        let child = childBuilder.buildChild(searchState.loadState,
                                            appCopyContent: appCopyContent,
                                            locationUpdateRequestBlock: locationUpdateRequestBlock)

        return SearchLookupViewModel(searchInputViewModel: searchInputViewModel,
                                     child: child)
    }

}
