//
//  SettingsPresenterSUI.swift
//  PlacesFinder
//
//  Created by Justin Peckner.
//  Copyright © 2020 Justin Peckner. All rights reserved.
//

import Shared
import SwiftDux
import SwiftUI
import UIKit

@available(iOS 13.0, *)
class SettingsPresenterSUI: SettingsPresenterProtocol {

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

    func loadSettingsView(_ viewModel: SettingsViewModel,
                          titleViewModel: NavigationBarTitleViewModel,
                          appSkin: AppSkin) {
        guard let existingSettingsView: SettingsViewSUI = rootControllerView() else {
            let settingsView = SettingsViewSUI(viewModel: viewModel,
                                               store: store)
            setRootController(settingsView,
                              titleViewModel: titleViewModel,
                              appSkin: appSkin)
            return
        }

        existingSettingsView.viewModel.value = viewModel
    }

}

@available(iOS 13.0, *)
private extension SettingsPresenterSUI {

    func rootControllerView<T: View>() -> T? {
        return (rootNavController.viewControllers.first as? UIHostingController<T>)?.rootView
    }

    func setRootController<T: View>(_ view: T,
                                    titleViewModel: NavigationBarTitleViewModel,
                                    appSkin: AppSkin) {
        let hostingController = UIHostingController(rootView: view)
        hostingController.configureTitleView(titleViewModel,
                                             appSkin: appSkin)
        rootNavController.setViewControllers([hostingController], animated: true)
    }

}
