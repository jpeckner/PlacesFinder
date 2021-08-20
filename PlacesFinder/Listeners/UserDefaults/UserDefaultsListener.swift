//
//  UserDefaultsListener.swift
//  PlacesFinder
//
//  Created by Justin Peckner.
//  Copyright © 2019 Justin Peckner. All rights reserved.
//

import Shared
import SwiftDux

protocol UserDefaultsListenerProtocol: AutoMockable {
    func start()
}

class UserDefaultsListener<
    TStore: SubscribableStoreProtocol
>: UserDefaultsListenerProtocol where TStore.State == AppState {

    private let store: TStore
    private let userDefaultsService: UserDefaultsServiceProtocol

    init(store: TStore,
         userDefaultsService: UserDefaultsServiceProtocol) {
        self.store = store
        self.userDefaultsService = userDefaultsService
    }

    func start() {
        store.subscribe(self, keyPath: \AppState.searchPreferencesState)
    }

}

extension UserDefaultsListener: SubstatesSubscriber {

    typealias StoreState = AppState

    func newState(state: AppState, updatedSubstates: Set<PartialKeyPath<AppState>>) {
        // Persisting searchPreferencesState each time the user changes it is a nice-to-have, but not essential to the
        // functionality of the app, so nothing we can or should do on the off-chance that this fails in production.
        AssertionHandler.assertIfErrorThrown {
            try userDefaultsService.setSearchPreferences(state.searchPreferencesState)
        }
    }

}
