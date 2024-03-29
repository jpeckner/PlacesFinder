//
//  SubstatesSubscriberRelay.swift
//  PlacesFinder
//
//  Copyright (c) 2022 Justin Peckner
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
import SwiftDux

struct SubstatesSubscriberRelayUpdate<TState: StateProtocol> {
    let state: TState
    let updatedSubstates: Set<PartialKeyPath<TState>>
}

class SubstatesSubscriberRelay<TStore: SubscribableStoreProtocol> {

    let store: TStore
    private let subject = PassthroughSubject<SubstatesSubscriberRelayUpdate<TStore.TState>, Never>()

    var publisher: AnyPublisher<SubstatesSubscriberRelayUpdate<TStore.TState>, Never> {
        subject.eraseToAnyPublisher()
    }

    init(store: TStore,
         equatableKeyPaths: Set<EquatableKeyPath<TStore.TState>>) {
        self.store = store

        store.subscribe(self,
                        equatableKeyPaths: equatableKeyPaths)
    }

}

extension SubstatesSubscriberRelay: SubstatesSubscriber {

    typealias StoreState = TStore.TState

    func newState(state: StoreState, updatedSubstates: Set<PartialKeyPath<StoreState>>) {
        let update = SubstatesSubscriberRelayUpdate(state: state,
                                                    updatedSubstates: updatedSubstates)
        subject.send(update)
    }

}
