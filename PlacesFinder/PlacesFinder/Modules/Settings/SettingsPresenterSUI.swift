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
        guard let existingView: SettingsViewSUI = existingRootView() else {
            let settingsView = SettingsViewSUI(viewModel: viewModel,
                                               colorings: appSkin.colorings.settings)
            setRootController(settingsView,
                              titleViewModel: titleViewModel,
                              appSkin: appSkin)
            return
        }

        existingView.configure(viewModel,
                               colorings: appSkin.colorings.settings)
    }

}

@available(iOS 13.0, *)
private extension SettingsPresenterSUI {

    func existingRootView<T: View>() -> T? {
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
