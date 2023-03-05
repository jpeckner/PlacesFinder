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

import Combine
import Shared
import SwiftDux

enum SearchInputViewModel: Equatable {
    case nonDispatching(content: SearchInputContentViewModel)

    case dispatching(content: SearchInputContentViewModel,
                     dispatcher: IgnoredEquatable<SearchInputDispatcher>)
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

struct SearchInputDispatcher {
    private let actionSubscriber: AnySubscriber<Search.Action, Never>
    private let actionPrism: SearchActivityActionPrismProtocol
    private let locationUpdateRequestBlock: LocationUpdateRequestBlock

    init(actionSubscriber: AnySubscriber<Search.Action, Never>,
         actionPrism: SearchActivityActionPrismProtocol,
         locationUpdateRequestBlock: @escaping LocationUpdateRequestBlock) {
        self.actionSubscriber = actionSubscriber
        self.actionPrism = actionPrism
        self.locationUpdateRequestBlock = locationUpdateRequestBlock
    }
}

extension SearchInputDispatcher {

    func dispatchEditEvent(_ editEvent: SearchBarEditEvent) {
        let action = actionPrism.updateEditingAction(editEvent)
        _ = actionSubscriber.receive(.searchActivity(action))
    }

    func dispatchSearchParams(_ params: SearchParams) {
        let action = actionPrism.initialRequestAction(
            params,
            locationUpdateRequestBlock: locationUpdateRequestBlock
        )
        _ = actionSubscriber.receive(.searchActivity(action))
    }

}

// MARK: SearchInputViewModelBuilder

// sourcery: AutoMockable
protocol SearchInputViewModelBuilderProtocol {
    func buildDispatchingViewModel(
        inputParams: SearchInputParams,
        copyContent: SearchInputCopyContent,
        locationUpdateRequestBlock: @escaping LocationUpdateRequestBlock
    ) -> SearchInputViewModel
}

class SearchInputViewModelBuilder: SearchInputViewModelBuilderProtocol {

    private let actionSubscriber: AnySubscriber<Search.Action, Never>
    private let actionPrism: SearchActivityActionPrismProtocol
    private let contentViewModelBuilder: SearchInputContentViewModelBuilderProtocol

    init(actionSubscriber: AnySubscriber<Search.Action, Never>,
         actionPrism: SearchActivityActionPrismProtocol,
         contentViewModelBuilder: SearchInputContentViewModelBuilderProtocol) {
        self.actionSubscriber = actionSubscriber
        self.actionPrism = actionPrism
        self.contentViewModelBuilder = contentViewModelBuilder
    }

    func buildDispatchingViewModel(
        inputParams: SearchInputParams,
        copyContent: SearchInputCopyContent,
        locationUpdateRequestBlock: @escaping LocationUpdateRequestBlock
    ) -> SearchInputViewModel {
        let contentViewModel = contentViewModelBuilder.buildViewModel(
            keywords: inputParams.params?.keywords,
            isEditing: inputParams.isEditing,
            isSearchInputVisible: inputParams.isSearchInputVisible,
            copyContent: copyContent
        )

        let dispatcher = SearchInputDispatcher(actionSubscriber: actionSubscriber,
                                               actionPrism: actionPrism,
                                               locationUpdateRequestBlock: locationUpdateRequestBlock)

        return .dispatching(content: contentViewModel,
                            dispatcher: IgnoredEquatable(dispatcher))
    }

}
