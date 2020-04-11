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
    func buildViewModel(_ store: DispatchingStoreProtocol,
                        actionPrism: SearchActionPrismProtocol,
                        searchState: SearchState,
                        appCopyContent: AppCopyContent,
                        locationUpdateRequestBlock: @escaping LocationUpdateRequestBlock) -> SearchLookupViewModel
}

class SearchLookupViewModelBuilder: SearchLookupViewModelBuilderProtocol {

    private let inputViewModelBuilder: SearchInputViewModelBuilderProtocol
    private let childBuilder: SearchLookupChildBuilderProtocol

    init(inputViewModelBuilder: SearchInputViewModelBuilderProtocol,
         childBuilder: SearchLookupChildBuilderProtocol) {
        self.inputViewModelBuilder = inputViewModelBuilder
        self.childBuilder = childBuilder
    }

    func buildViewModel(_ store: DispatchingStoreProtocol,
                        actionPrism: SearchActionPrismProtocol,
                        searchState: SearchState,
                        appCopyContent: AppCopyContent,
                        locationUpdateRequestBlock: @escaping LocationUpdateRequestBlock) -> SearchLookupViewModel {
        let searchInputViewModel = inputViewModelBuilder.buildViewModel(
            searchState.inputParams,
            copyContent: appCopyContent.searchInput,
            locationUpdateRequestBlock: locationUpdateRequestBlock
        )

        let child = childBuilder.buildChild(store,
                                            actionPrism: actionPrism,
                                            loadState: searchState.loadState,
                                            appCopyContent: appCopyContent,
                                            locationUpdateRequestBlock: locationUpdateRequestBlock)

        return SearchLookupViewModel(searchInputViewModel: searchInputViewModel,
                                     child: child)
    }

}
