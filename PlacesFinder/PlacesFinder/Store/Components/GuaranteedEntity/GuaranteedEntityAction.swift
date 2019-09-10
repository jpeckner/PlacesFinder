//
//  GuaranteedEntityAction.swift
//  PlacesFinder
//
//  Created by Justin Peckner.
//  Copyright © 2018 Justin Peckner. All rights reserved.
//

import Foundation
import Shared
import SwiftDux

enum GuaranteedEntityAction<T: Equatable>: Action, Equatable {
    case inProgress
    case success(T)
    case failure(EntityError)
}

protocol GuaranteedEntityActionCreator {}

extension GuaranteedEntityActionCreator {

    static func loadGuaranteedEntity<T: Equatable, E: Error>(_ loadBlock: EntityLoadBlock<T, E>) -> AppAsyncAction {
        return AppAsyncAction { dispatch, _ in
            dispatch(GuaranteedEntityAction<T>.inProgress)

            switch loadBlock {
            case let .nonThrowing(block):
                block { result in
                    dispatchResult(result,
                                   dispatch: dispatch)
                }
            case let .throwing(block):
                do {
                    try block { result in
                        dispatchResult(result,
                                       dispatch: dispatch)
                    }
                } catch {
                    let entityError = EntityError.preloadError(underlyingError: IgnoredEquatable(error))
                    dispatch(GuaranteedEntityAction<T>.failure(entityError))
                }
            }
        }
    }

    private static func dispatchResult<T: Equatable, E: Error>(_ result: Result<T, E>,
                                                               dispatch: DispatchFunction) {
        switch result {
        case let .success(entity):
            dispatch(GuaranteedEntityAction<T>.success(entity))
        case let .failure(error):
            let entityError = EntityError.loadError(underlyingError: IgnoredEquatable(error))
            dispatch(GuaranteedEntityAction<T>.failure(entityError))
        }
    }

}
