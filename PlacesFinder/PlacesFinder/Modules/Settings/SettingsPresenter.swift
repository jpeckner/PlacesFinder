//
//  SettingsPresenter.swift
//  PlacesFinder
//
//  Created by Justin Peckner.
//  Copyright © 2019 Justin Peckner. All rights reserved.
//

import Shared
import SwiftDux
import SwiftUI
import UIKit

class SettingsPresenter: SettingsPresenterProtocol {

    let rootNavController: UINavigationController
    private let formatter: MeasurementFormatter
    private let store: DispatchingStoreProtocol

    init(tabItemProperties: TabItemProperties,
         store: DispatchingStoreProtocol) {
        self.rootNavController = UINavigationController()
        rootNavController.configure(tabItemProperties)

        self.formatter = MeasurementFormatter()
        formatter.unitOptions = .providedUnit

        self.store = store
    }

    func loadSettingsView(_ state: AppState) {
        let viewModel = SettingsViewModel(searchPreferencesState: state.searchPreferencesState,
                                          formatter: formatter,
                                          appCopyContent: state.appCopyContentState.copyContent)
        let settingsController: SettingsViewController =
            rootNavController.viewControllers.first as? SettingsViewController
            ?? SettingsViewController(store: store,
                                      appSkin: state.appSkinState.currentValue)
        settingsController.viewModel = viewModel

        settingsController.configureTitleView(state)
        rootNavController.setViewControllers([settingsController], animated: true)
    }

}
