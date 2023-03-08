//
//  SettingsPresenter.swift
//  PlacesFinder
//
//  Copyright (c) 2019 Justin Peckner
//  
//  Permission is hereby granted, free of charge, to any person obtaining a copy
//  of this software and associated documentation files (the "Software"), to deal
//  in the Software without restriction, including without limitation the rights
//  to use, copy, modify, merge, publish, distribute, sublicense, and/or sell
//  copies of the Software, and to permit persons to whom the Software is
//  furnished to do so, subject to the following conditions:
//  
//  The above copyright notice and this permission notice shall be included in all
//  copies or substantial portions of the Software.
//  
//  THE SOFTWARE IS PROVIDED "AS IS", WITHOUT WARRANTY OF ANY KIND, EXPRESS OR
//  IMPLIED, INCLUDING BUT NOT LIMITED TO THE WARRANTIES OF MERCHANTABILITY,
//  FITNESS FOR A PARTICULAR PURPOSE AND NONINFRINGEMENT. IN NO EVENT SHALL THE
//  AUTHORS OR COPYRIGHT HOLDERS BE LIABLE FOR ANY CLAIM, DAMAGES OR OTHER
//  LIABILITY, WHETHER IN AN ACTION OF CONTRACT, TORT OR OTHERWISE, ARISING FROM,
//  OUT OF OR IN CONNECTION WITH THE SOFTWARE OR THE USE OR OTHER DEALINGS IN THE
//  SOFTWARE.

import Shared
import SwiftDux
import UIKit

// sourcery: AutoMockable
@MainActor protocol SettingsPresenterProtocol {
    var rootNavController: UINavigationController { get }

    func loadSettingsView(_ viewModel: SettingsViewModel,
                          titleViewModel: NavigationBarTitleViewModel,
                          appSkin: AppSkin)
}

@MainActor
class SettingsPresenter: SettingsPresenterProtocol {

    let rootNavController: UINavigationController

    init(tabItemProperties: TabItemProperties) {
        self.rootNavController = UINavigationController()
        rootNavController.configure(tabItemProperties)
    }

    func loadSettingsView(_ viewModel: SettingsViewModel,
                          titleViewModel: NavigationBarTitleViewModel,
                          appSkin: AppSkin) {
        guard let existingController: SettingsViewController = existingRootController() else {
            let controller = buildSettingsViewController(viewModel,
                                                         titleViewModel: titleViewModel,
                                                         appSkin: appSkin)
            rootNavController.setViewControllers([controller], animated: true)
            return
        }

        existingController.configure(viewModel,
                                     colorings: appSkin.colorings.settings)
    }

}

private extension SettingsPresenter {

    func existingRootController<T: UIViewController>() -> T? {
        return rootNavController.viewControllers.first as? T
    }

}

private extension SettingsPresenter {

    func buildSettingsViewController(_ viewModel: SettingsViewModel,
                                     titleViewModel: NavigationBarTitleViewModel,
                                     appSkin: AppSkin) -> SettingsViewController {
        let controller = SettingsViewController(viewModel: viewModel,
                                                colorings: appSkin.colorings.settings)
        controller.configureTitleView(titleViewModel,
                                      appSkin: appSkin)
        return controller
    }

}
