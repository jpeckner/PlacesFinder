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

protocol SettingsPresenterProtocol: AutoMockable {
    var rootNavController: UINavigationController { get }

    func loadSettingsView(_ state: AppState)
}

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

    func loadSettingsView(_ state: AppState) {
        let viewModel = SettingsViewModel(searchPreferencesState: state.searchPreferencesState,
                                          formatter: formatter,
                                          appCopyContent: state.appCopyContentState.copyContent)

        if let observableViewModel = observableViewModel {
            observableViewModel.viewModel = viewModel
            return
        }

        let observable = SettingsViewModelObservable(viewModel: viewModel)
        observableViewModel = observable

        let settingsView = SettingsViewSUI(viewModel: observable,
                                           store: store)
        let hostingController = UIHostingController(rootView: settingsView)
        hostingController.configureTitleView(state)
        rootNavController.setViewControllers([hostingController], animated: true)
    }

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
