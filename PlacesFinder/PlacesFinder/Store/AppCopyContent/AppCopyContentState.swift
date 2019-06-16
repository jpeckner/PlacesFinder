//
//  AppCopyContentState.swift
//  PlacesFinder
//
//  Created by Justin Peckner.
//  Copyright © 2019 Justin Peckner. All rights reserved.
//

import SwiftDux

struct AppCopyContentState {
    let copyContent: AppCopyContent
}

enum AppCopyContentReducer {

    static func reduce(action: Action,
                       currentState: AppCopyContentState) -> AppCopyContentState {
        return currentState
    }

}
