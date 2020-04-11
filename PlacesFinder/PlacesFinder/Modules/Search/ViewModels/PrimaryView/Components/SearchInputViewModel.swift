//
//  SearchInputViewModel.swift
//  PlacesFinder
//
//  Created by Justin Peckner.
//  Copyright © 2019 Justin Peckner. All rights reserved.
//

import Shared
import SwiftDux

struct SearchInputViewModel: Equatable {
    let content: SearchInputContentViewModel
    private let store: IgnoredEquatable<DispatchingStoreProtocol>
    private let actionPrism: IgnoredEquatable<SearchActionPrismProtocol>
    private let locationUpdateRequestBlock: IgnoredEquatable<LocationUpdateRequestBlock>

    init(content: SearchInputContentViewModel,
         store: DispatchingStoreProtocol,
         actionPrism: SearchActionPrismProtocol,
         locationUpdateRequestBlock: @escaping LocationUpdateRequestBlock) {
        self.content = content
        self.store = IgnoredEquatable(store)
        self.actionPrism = IgnoredEquatable(actionPrism)
        self.locationUpdateRequestBlock = IgnoredEquatable(locationUpdateRequestBlock)
    }
}

extension SearchInputViewModel {

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
    func buildViewModel(_ inputParams: SearchInputParams,
                        copyContent: SearchInputCopyContent,
                        locationUpdateRequestBlock: @escaping LocationUpdateRequestBlock) -> SearchInputViewModel
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

    func buildViewModel(_ inputParams: SearchInputParams,
                        copyContent: SearchInputCopyContent,
                        locationUpdateRequestBlock: @escaping LocationUpdateRequestBlock) -> SearchInputViewModel {
        let contentViewModel = contentViewModelBuilder.buildViewModel(keywords: inputParams.params?.keywords,
                                                                      isEditing: inputParams.isEditing,
                                                                      copyContent: copyContent)

        return SearchInputViewModel(content: contentViewModel,
                                    store: store,
                                    actionPrism: actionPrism,
                                    locationUpdateRequestBlock: locationUpdateRequestBlock)
    }

}
