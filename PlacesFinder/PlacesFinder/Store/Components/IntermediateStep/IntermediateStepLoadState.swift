//
//  IntermediateStepLoadState.swift
//  PlacesFinder
//
//  Created by Justin Peckner.
//  Copyright © 2019 Justin Peckner. All rights reserved.
//

import Foundation

enum IntermediateStepLoadState<E: Error & Equatable>: Equatable {
    case inProgress
    case success
    case failure(E)
}

enum IntermediateStepLoadReducer<E: Error & Equatable> {

    static func reduce(action: IntermediateStepLoadAction<E>,
                       currentState: IntermediateStepLoadState<E>?) -> IntermediateStepLoadState<E> {
        guard currentState != nil else { return .inProgress }

        switch action {
        case .inProgress:
            return .inProgress
        case .success:
            return .success
        case let .failure(errorBox):
            return .failure(errorBox)
        }
    }

}
