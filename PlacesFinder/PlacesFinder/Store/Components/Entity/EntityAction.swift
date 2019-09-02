//
//  EntityAction.swift
//  PlacesFinder
//
//  Created by Justin Peckner on 11/10/18.
//  Copyright © 2018 Justin Peckner. All rights reserved.
//

import Foundation
import Shared
import SwiftDux

enum EntityAction<T: Equatable>: Action, Equatable {
    case idle
    case inProgress
    case success(T)
    case failure(EntityError)
}

protocol EntityActionCreator {}

extension EntityActionCreator {

    static func loadEntity<T: Equatable, E: Error>(_ loadBlock: EntityLoadBlock<T, E>) -> AppAsyncAction {
        return AppAsyncAction { dispatch, _ in
            dispatch(EntityAction<T>.inProgress)

            switch loadBlock {
            case let .nonThrowing(block):
                block { taskResult in
                    dispatchTaskResult(taskResult: taskResult, dispatch: dispatch)
                }
            case let .throwing(block):
                do {
                    try block { taskResult in
                        dispatchTaskResult(taskResult: taskResult, dispatch: dispatch)
                    }
                } catch {
                    let entityError = EntityError.preloadError(underlyingError: IgnoredEquatable(error))
                    dispatch(EntityAction<T>.failure(entityError))
                }
            }
        }
    }

    private static func dispatchTaskResult<T: Equatable, E: Error>(taskResult: Result<T, E>,
                                                                   dispatch: DispatchFunction) {
        switch taskResult {
        case let .success(entity):
            dispatch(EntityAction<T>.success(entity))
        case let .failure(error):
            let entityError = EntityError.loadError(underlyingError: IgnoredEquatable(error))
            dispatch(EntityAction<T>.failure(entityError))
        }
    }

}
