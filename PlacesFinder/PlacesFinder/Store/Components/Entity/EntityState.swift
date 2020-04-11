//
//  EntityState.swift
//  PlacesFinder
//
//  Created by Justin Peckner on 11/10/18.
//  Copyright © 2018 Justin Peckner. All rights reserved.
//

import Foundation
import Shared
import SwiftDux

// MARK: LoadState

enum EntityLoadState<T: Equatable>: Equatable {
    case idle
    case inProgress
    case success(T)
    case failure(EntityError)
}

// MARK: EntityState

struct EntityState<T: Equatable>: Equatable {
    let loadState: EntityLoadState<T>
    let currentValue: T?
}

extension EntityState {

    init() {
        self.loadState = .idle
        self.currentValue = nil
    }

}

// MARK: EntityReducer

enum EntityReducer<T: Equatable> {

    static func reduce(action: Action, currentState: EntityState<T>) -> EntityState<T> {
        guard let entityAction = action as? EntityAction<T> else {
            return currentState
        }

        switch entityAction {
        case .idle:
            return EntityState(loadState: .idle,
                               currentValue: currentState.currentValue)
        case .inProgress:
            return EntityState(loadState: .inProgress,
                               currentValue: currentState.currentValue)
        case let .success(entity):
            return EntityState(loadState: .success(entity),
                               currentValue: entity)
        case let .failure(entityError):
            return EntityState(loadState: .failure(entityError),
                               currentValue: currentState.currentValue)
        }
    }

}
