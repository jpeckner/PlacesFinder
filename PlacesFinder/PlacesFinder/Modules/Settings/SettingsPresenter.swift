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

class SettingsPresenter: SettingsPresenterProtocol {

    let rootNavController: UINavigationController
    private let store: DispatchingStoreProtocol

    init(tabItemProperties: TabItemProperties,
         store: DispatchingStoreProtocol) {
        self.rootNavController = UINavigationController()
        rootNavController.configure(tabItemProperties)

        self.store = store
    }

    func loadSettingsView(_ viewModel: SettingsViewModel,
                          titleViewModel: NavigationBarTitleViewModel,
                          appSkin: AppSkin) {
        guard let existingController = rootNavController.viewControllers.first as? SettingsViewController else {
            let controller = buildSettingsViewController(viewModel,
                                                         titleViewModel: titleViewModel,
                                                         appSkin: appSkin)
            rootNavController.setViewControllers([controller], animated: true)
            return
        }

        existingController.configure(viewModel)
    }

}

private extension SettingsPresenter {

    func buildSettingsViewController(_ viewModel: SettingsViewModel,
                                     titleViewModel: NavigationBarTitleViewModel,
                                     appSkin: AppSkin) -> SettingsViewController {
        let controller = SettingsViewController(viewModel: viewModel,
                                                store: store,
                                                appSkin: appSkin)
        controller.configureTitleView(titleViewModel,
                                      appSkin: appSkin)
        return controller
    }

}
