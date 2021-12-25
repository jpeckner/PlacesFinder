//
//  UserDefaultsListener.swift
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
