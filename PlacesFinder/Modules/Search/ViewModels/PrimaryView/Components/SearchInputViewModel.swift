//
//  SearchInputViewModel.swift
//  PlacesFinder
//
//  Copyright (c) 2019 Justin Peckner
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

enum SearchInputViewModel: Equatable {
    case nonDispatching(content: SearchInputContentViewModel)

    case dispatching(content: SearchInputContentViewModel,
                     dispatcher: SearchInputDispatcher)
}

extension SearchInputViewModel {

    var content: SearchInputContentViewModel {
        switch self {
        case let .nonDispatching(content),
             let .dispatching(content, _):
            return content
        }
    }

}

struct SearchInputDispatcher: Equatable {
    private let store: IgnoredEquatable<DispatchingStoreProtocol>
    private let actionPrism: IgnoredEquatable<SearchActionPrismProtocol>
    private let locationUpdateRequestBlock: IgnoredEquatable<LocationUpdateRequestBlock>

    init(store: DispatchingStoreProtocol,
         actionPrism: SearchActionPrismProtocol,
         locationUpdateRequestBlock: @escaping LocationUpdateRequestBlock) {
        self.store = IgnoredEquatable(store)
        self.actionPrism = IgnoredEquatable(actionPrism)
        self.locationUpdateRequestBlock = IgnoredEquatable(locationUpdateRequestBlock)
    }
}

extension SearchInputDispatcher {

    func dispatchEditEvent(_ editEvent: SearchBarEditEvent) {
        let action = actionPrism.value.updateEditingAction(editEvent)
        store.value.dispatch(action)
    }

    func dispatchSearchParams(_ params: SearchParams) {
        let action = actionPrism.value.initialRequestAction(
            params,
            locationUpdateRequestBlock: locationUpdateRequestBlock.value
        )
        store.value.dispatch(action)
    }

}

// MARK: SearchInputViewModelBuilder

protocol SearchInputViewModelBuilderProtocol: AutoMockable {
    func buildDispatchingViewModel(
        _ inputParams: SearchInputParams,
        copyContent: SearchInputCopyContent,
        locationUpdateRequestBlock: @escaping LocationUpdateRequestBlock
    ) -> SearchInputViewModel
}

class SearchInputViewModelBuilder: SearchInputViewModelBuilderProtocol {

    private let store: DispatchingStoreProtocol
    private let actionPrism: SearchActionPrismProtocol
    private let contentViewModelBuilder: SearchInputContentViewModelBuilderProtocol

    init(store: DispatchingStoreProtocol,
         actionPrism: SearchActionPrismProtocol,
         contentViewModelBuilder: SearchInputContentViewModelBuilderProtocol) {
        self.store = store
        self.actionPrism = actionPrism
        self.contentViewModelBuilder = contentViewModelBuilder
    }

    func buildDispatchingViewModel(
        _ inputParams: SearchInputParams,
        copyContent: SearchInputCopyContent,
        locationUpdateRequestBlock: @escaping LocationUpdateRequestBlock
    ) -> SearchInputViewModel {
        let contentViewModel = contentViewModelBuilder.buildViewModel(keywords: inputParams.params?.keywords,
                                                                      isEditing: inputParams.isEditing,
                                                                      copyContent: copyContent)

        let dispatcher = SearchInputDispatcher(store: store,
                                               actionPrism: actionPrism,
                                               locationUpdateRequestBlock: locationUpdateRequestBlock)

        return .dispatching(content: contentViewModel,
                            dispatcher: dispatcher)
    }

}
