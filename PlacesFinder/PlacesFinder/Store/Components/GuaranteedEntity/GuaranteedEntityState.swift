//
//  GuaranteedEntityState.swift
//  PlacesFinder
//
//  Created by Justin Peckner.
//  Copyright © 2018 Justin Peckner. All rights reserved.
//

import Foundation
import Shared
import SwiftDux

// MARK: GuaranteedLoadState

enum GuaranteedEntityLoadState<TEntity: Equatable>: Action, Equatable {
    case idle
    case inProgress
    case success(TEntity)
    case failure(EntityError)
}

// MARK: GuaranteedEntityState

protocol GuaranteedEntityState {
    associatedtype TEntity: Equatable

    static var fallbackValue: TEntity { get }

    init(loadState: GuaranteedEntityLoadState<TEntity>)
    var loadState: GuaranteedEntityLoadState<TEntity> { get }
}

extension GuaranteedEntityState {

    init() {
        self.init(loadState: .idle)
    }

    var currentValue: TEntity {
        switch loadState {
        case let .success(entity):
            return entity
        case .idle, .inProgress, .failure:
            return Self.fallbackValue
        }
    }

    var hasCompletedLoading: Bool {
        switch loadState {
        case .idle, .inProgress:
            return false
        case .success, .failure:
            return true
        }
    }

}

// MARK: GuaranteedEntityReducer

enum GuaranteedEntityReducer<State: GuaranteedEntityState> {

    static func reduce(action: Action, currentState: State) -> State {
        guard let entityAction = action as? GuaranteedEntityAction<State.TEntity> else { return currentState }

        switch entityAction {
        case .inProgress:
            return State(loadState: .inProgress)
        case let .success(entity):
            return State(loadState: .success(entity))
        case let .failure(entityError):
            return State(loadState: .failure(entityError))
        }
    }

}
