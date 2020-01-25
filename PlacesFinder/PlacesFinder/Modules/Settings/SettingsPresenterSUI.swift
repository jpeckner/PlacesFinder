//
//  SettingsPresenterSUI.swift
//  PlacesFinder
//
//  Created by Justin Peckner.
//  Copyright © 2020 Justin Peckner. All rights reserved.
//

import SwiftDux
import SwiftUI
import UIKit

@available(iOS 13.0, *)
class SettingsPresenterSUI: SettingsPresenterProtocol {

    let rootNavController: UINavigationController
    private let formatter: MeasurementFormatter
    private let store: DispatchingStoreProtocol
    private var observableViewModel: SettingsViewModelObservable?

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
        if let observableViewModel = observableViewModel {
            observableViewModel.viewModel = viewModel
            return
        }

        let observable = SettingsViewModelObservable(viewModel: viewModel)
        observableViewModel = observable

        let settingsView = SettingsViewSUI(viewModel: observable,
                                           store: store)
        let hostingController = UIHostingController(rootView: settingsView)
        hostingController.configureTitleView(titleViewModel,
                                             appSkin: appSkin)
        rootNavController.setViewControllers([hostingController], animated: true)
    }

}
