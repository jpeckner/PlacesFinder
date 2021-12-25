//
//  AppSkinState.swift
//  PlacesFinder
//
//  Created by Justin Peckner.
//  Copyright © 2018 Justin Peckner. All rights reserved.
//

import Foundation
import SwiftDux

struct AppSkinState: GuaranteedEntityState, Equatable {
    typealias TEntity = AppSkin
    static let fallbackValue = AppSkin(colorings: AppColorings.defaultColorings)

    let loadState: GuaranteedEntityLoadState<TEntity>

    init(loadState: GuaranteedEntityLoadState<TEntity>) {
        self.loadState = loadState
    }
}

typealias AppSkinReducer = GuaranteedEntityReducer<AppSkinState>
