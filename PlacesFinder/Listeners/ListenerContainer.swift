//
//  ListenerContainer.swift
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
import Reachability
import Shared
import SwiftDux

struct ListenerContainer {
    let locationAuthListener: LocationAuthListenerProtocol
    let reachabilityListener: ReachabilityListenerProtocol?
    let userDefaultsListener: UserDefaultsListenerProtocol

    private var cancellables: Set<AnyCancellable> = []
}

extension ListenerContainer {

    init(store: Store<AppState>,
         locationAuthManager: CLLocationManagerAuthProtocol,
         userDefaultsService: UserDefaultsServiceProtocol) {
        self.locationAuthListener = LocationAuthListener(store: store,
                                                         locationAuthManager: locationAuthManager)

        // Use of the Reachability library enhances the app experience (it allows us to show a "No internet" message
        // rather than a less specific error), but the app still functions correctly on the off-chance that
        // Reachability.init() returns nil.
        do {
            let reachability = try Reachability()
            let listener = ReachabilityListener(reachability: reachability)
            self.reachabilityListener = listener

            listener.actionPublisher
                .sink(receiveValue: store.dispatch)
                .store(in: &cancellables)
        } catch {
            self.reachabilityListener = nil
        }

        self.userDefaultsListener = UserDefaultsListener(store: store,
                                                         userDefaultsService: userDefaultsService)
    }

}
