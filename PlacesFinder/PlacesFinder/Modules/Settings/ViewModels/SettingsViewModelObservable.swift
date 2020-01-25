//
//  SettingsViewModelObservable.swift
//  PlacesFinder
//
//  Created by Justin Peckner.
//  Copyright © 2020 Justin Peckner. All rights reserved.
//

import Foundation

@available(iOS 13.0, *)
class SettingsViewModelObservable: ObservableObject {
    @Published var viewModel: SettingsViewModel

    init(viewModel: SettingsViewModel) {
        self._viewModel = Published(initialValue: viewModel)
    }
}
