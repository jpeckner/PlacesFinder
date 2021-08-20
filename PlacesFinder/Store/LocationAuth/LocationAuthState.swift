//
//  LocationAuthState.swift
//  PlacesFinder
//
//  Created by Justin Peckner.
//  Copyright © 2018 Justin Peckner. All rights reserved.
//

import Foundation
import Shared
import SwiftDux

struct LocationAuthState: Equatable {
    let authStatus: LocationAuthStatus
}

enum LocationAuthReducer {

    static func reduce(action: Action,
                       currentState: LocationAuthState) -> LocationAuthState {
        guard let locationAuthAction = action as? LocationAuthAction else { return currentState }

        switch locationAuthAction {
        case .notDetermined:
            return LocationAuthState(authStatus: .notDetermined)
        case .locationServicesEnabled:
            return LocationAuthState(authStatus: .locationServicesEnabled)
        case .locationServicesDisabled:
            return LocationAuthState(authStatus: .locationServicesDisabled)
        }
    }

}
