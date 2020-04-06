//
//  SettingsCellViewModel.swift
//  PlacesFinder
//
//  Created by Justin Peckner.
//  Copyright © 2020 Justin Peckner. All rights reserved.
//

import Foundation
import Shared
import SwiftDux

struct SettingsCellViewModel {
    let cellModel: GroupedTableViewCellModel
    private let store: DispatchingStoreProtocol
    private let action: Action

    init(cellModel: GroupedTableViewCellModel,
         store: DispatchingStoreProtocol,
         action: Action) {
        self.cellModel = cellModel
        self.store = store
        self.action = action
    }
}

extension SettingsCellViewModel {

    func dispatchAction() {
        store.dispatch(action)
    }

}
