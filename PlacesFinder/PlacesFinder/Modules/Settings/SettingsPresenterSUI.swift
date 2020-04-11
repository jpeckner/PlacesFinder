//
//  SettingsPresenterSUI.swift
//  PlacesFinder
//
//  Created by Justin Peckner.
//  Copyright © 2020 Justin Peckner. All rights reserved.
//

import Shared
import SwiftUI
import UIKit

@available(iOS 13.0, *)
class SettingsPresenterSUI: SettingsPresenterProtocol {

    let rootNavController: UINavigationController

    init(tabItemProperties: TabItemProperties) {
        self.rootNavController = UINavigationController()
        rootNavController.configure(tabItemProperties)
    }

    func loadSettingsView(_ viewModel: SettingsViewModel,
                          titleViewModel: NavigationBarTitleViewModel,
                          appSkin: AppSkin) {
        guard let existingSettingsView: SettingsViewSUI = rootControllerView() else {
            let settingsView = SettingsViewSUI(viewModel: viewModel)
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
