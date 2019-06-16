//
//  ReachabilityListener.swift
//  PlacesFinder
//
//  Created by Justin Peckner.
//  Copyright © 2019 Justin Peckner. All rights reserved.
//

import Shared
import SwiftDux

protocol ReachabilityListenerProtocol: AutoMockable {
    func start() throws
}

class ReachabilityListener: ReachabilityListenerProtocol {

    private let store: DispatchingStoreProtocol
    private let reachability: ReachabilityProtocol

    init(store: DispatchingStoreProtocol,
         reachability: ReachabilityProtocol) {
        self.store = store
        self.reachability = reachability
    }

    func start() throws {
        reachability.setReachabilityCallback { [weak self] status in
            switch status {
            case .unreachable:
                self?.store.dispatch(ReachabilityAction.unreachable)
            case let .reachable(connectionType):
                self?.store.dispatch(ReachabilityAction.reachable(connectionType))
            }
        }

        try reachability.startNotifier()
    }

}
