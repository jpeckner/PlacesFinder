//
//  SearchLookupViewModel.swift
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

import Foundation
import Shared
import SwiftDux

struct SearchLookupViewModel: Equatable {
    let searchInputViewModel: SearchInputViewModel
    let child: SearchLookupChild
}

protocol SearchLookupViewModelBuilderProtocol: AutoMockable {
    func buildViewModel(_ searchActivityState: SearchActivityState,
                        appCopyContent: AppCopyContent,
                        locationUpdateRequestBlock: @escaping LocationUpdateRequestBlock) -> SearchLookupViewModel
}

class SearchLookupViewModelBuilder: SearchLookupViewModelBuilderProtocol {

    private let store: DispatchingStoreProtocol
    private let actionPrism: SearchActivityActionPrismProtocol
    private let inputViewModelBuilder: SearchInputViewModelBuilderProtocol
    private let childBuilder: SearchLookupChildBuilderProtocol

    init(store: DispatchingStoreProtocol,
         actionPrism: SearchActivityActionPrismProtocol,
         inputViewModelBuilder: SearchInputViewModelBuilderProtocol,
         childBuilder: SearchLookupChildBuilderProtocol) {
        self.store = store
        self.actionPrism = actionPrism
        self.inputViewModelBuilder = inputViewModelBuilder
        self.childBuilder = childBuilder
    }

    func buildViewModel(_ searchActivityState: SearchActivityState,
                        appCopyContent: AppCopyContent,
                        locationUpdateRequestBlock: @escaping LocationUpdateRequestBlock) -> SearchLookupViewModel {
        let searchInputViewModel = inputViewModelBuilder.buildDispatchingViewModel(
            searchActivityState.inputParams,
            copyContent: appCopyContent.searchInput,
            locationUpdateRequestBlock: locationUpdateRequestBlock
        )

        let child = childBuilder.buildChild(searchActivityState.loadState,
                                            appCopyContent: appCopyContent,
                                            locationUpdateRequestBlock: locationUpdateRequestBlock)

        return SearchLookupViewModel(searchInputViewModel: searchInputViewModel,
                                     child: child)
    }

}
