//
//  ReachabilityState.swift
//  PlacesFinder
//
//  Created by Justin Peckner.
//  Copyright © 2019 Justin Peckner. All rights reserved.
//

import SwiftDux

struct ReachabilityState: Equatable {
    let status: ReachabilityStatus?
}

extension ReachabilityState {

    init() {
        self.status = nil
    }

}

enum ReachabilityReducer {

    static func reduce(action: Action,
                       currentState: ReachabilityState) -> ReachabilityState {
        guard let reachabilityAction = action as? ReachabilityAction else { return currentState }

        switch reachabilityAction {
        case .unreachable:
            return ReachabilityState(status: .unreachable)
        case let .reachable(connectionType):
            return ReachabilityState(status: .reachable(connectionType))
        }
    }

}
