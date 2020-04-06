//
//  SearchInputViewModel.swift
//  PlacesFinder
//
//  Created by Justin Peckner.
//  Copyright © 2019 Justin Peckner. All rights reserved.
//

import SwiftDux

struct SearchInputViewModel {
    let content: SearchInputContentViewModel
    private let store: DispatchingStoreProtocol
    private let actionPrism: SearchActionPrismProtocol
    private let locationUpdateRequestBlock: LocationUpdateRequestBlock

    init(content: SearchInputContentViewModel,
         store: DispatchingStoreProtocol,
         actionPrism: SearchActionPrismProtocol,
         locationUpdateRequestBlock: @escaping LocationUpdateRequestBlock) {
        self.content = content
        self.store = store
        self.actionPrism = actionPrism
        self.locationUpdateRequestBlock = locationUpdateRequestBlock
    }
}

extension SearchInputViewModel {

    func dispatchEditAction(_ editAction: SearchBarEditAction) {
        let action = actionPrism.updateEditingAction(editAction)
        store.dispatch(action)
    }

    func dispatchSearchParams(_ params: SearchParams) {
        let action = actionPrism.initialRequestAction(params,
                                                      locationUpdateRequestBlock: locationUpdateRequestBlock)
        store.dispatch(action)
    }

}
