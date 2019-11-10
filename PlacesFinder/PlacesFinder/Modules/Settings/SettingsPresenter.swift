//
//  SettingsPresenter.swift
//  PlacesFinder
//
//  Created by Justin Peckner.
//  Copyright © 2019 Justin Peckner. All rights reserved.
//

import Shared
import SwiftDux
import UIKit

protocol SettingsPresenterProtocol: AutoMockable {
    var rootNavController: UINavigationController { get }

    func loadSettingsView(_ state: AppState)
}

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
        let controller: SettingsViewController =
            (rootNavController.viewControllers.first as? SettingsViewController)
            ?? buildSettingsViewController(state)

        controller.configure(state: state)
        rootNavController.setViewControllers([controller], animated: true)
    }

}

private extension SettingsPresenter {

    func buildSettingsViewController(_ state: AppState) -> SettingsViewController {
        let controller = SettingsViewController(store: store,
                                                formatter: formatter,
                                                appSkin: state.appSkinState.currentValue)
//        controller.configureTitleView(state.appSkinState.currentValue,
//                                      appCopyContent: state.appCopyContentState.copyContent)
        return controller
    }

}
