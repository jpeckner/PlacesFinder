//
//  SettingsViewModelObservable.swift
//  PlacesFinder
//
//  Created by Justin Peckner.
//  Copyright © 2020 Justin Peckner. All rights reserved.
//

import Foundation

class SettingsViewModelObservable: ObservableObject {
    @Published var value: SettingsViewModel

    init(viewModel: SettingsViewModel) {
        self._value = Published(initialValue: viewModel)
    }
}
