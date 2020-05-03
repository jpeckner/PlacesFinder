//
//  LaunchStatePrism.swift
//  PlacesFinder
//
//  Created by Justin Peckner.
//  Copyright © 2019 Justin Peckner. All rights reserved.
//

import Shared
import SwiftDux
import SwiftDuxExtensions

protocol LaunchStatePrismProtocol: AutoMockable {
    var launchKeyPaths: Set<EquatableKeyPath<AppState>> { get }

    func hasFinishedLaunching(_ state: AppState) -> Bool
}

class LaunchStatePrism: LaunchStatePrismProtocol {

    var launchKeyPaths: Set<EquatableKeyPath<AppState>> {
        return [
            EquatableKeyPath(\AppState.appSkinState),
        ]
    }

    func hasFinishedLaunching(_ state: AppState) -> Bool {
        return state.appSkinState.hasCompletedLoading
    }

}
