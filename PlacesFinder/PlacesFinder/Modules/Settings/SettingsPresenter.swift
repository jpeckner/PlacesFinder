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

    func loadSettingsView(_ viewModel: SettingsViewModel,
                          appSkin: AppSkin,
                          appCopyContent: AppCopyContent)
}

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
                          appSkin: AppSkin,
                          appCopyContent: AppCopyContent) {
        let controller: SettingsViewController
        if let existingController = rootNavController.viewControllers.first as? SettingsViewController {
            controller = existingController
            controller.configure(viewModel)
        } else {
            controller = buildSettingsViewController(viewModel,
                                                     appSkin: appSkin,
                                                     appCopyContent: appCopyContent)
        }

        rootNavController.setViewControllers([controller], animated: true)
    }

}

private extension SettingsPresenter {

    func buildSettingsViewController(_ viewModel: SettingsViewModel,
                                     appSkin: AppSkin,
                                     appCopyContent: AppCopyContent) -> SettingsViewController {
        let controller = SettingsViewController(viewModel: viewModel,
                                                store: store,
                                                appSkin: appSkin)
        controller.configureTitleView(appSkin,
                                      appCopyContent: appCopyContent)
        return controller
    }

}
