//
//  SettingsCoordinator.swift
//  PlacesFinder
//
//  Created by Justin Peckner.
//  Copyright © 2019 Justin Peckner. All rights reserved.
//

import CoordiNode
import SwiftDux
import UIKit

// sourcery: linkPayloadType = "SettingsLinkPayload"
class SettingsCoordinator<TStore: StoreProtocol> where TStore.State == AppState {

    private let store: TStore
    private let presenter: SettingsPresenterProtocol
    private let measurementFormatter: MeasurementFormatterProtocol

    init(store: TStore,
         presenter: SettingsPresenterProtocol,
         measurementFormatter: MeasurementFormatterProtocol) {
        self.store = store
        self.presenter = presenter
        self.measurementFormatter = measurementFormatter

        store.subscribe(self, keyPath: \AppState.searchPreferencesState)
    }

}

extension SettingsCoordinator: TabCoordinatorProtocol {

    var rootViewController: UIViewController {
        return presenter.rootNavController
    }

}

extension SettingsCoordinator: SubstatesSubscriber {

    typealias StoreState = AppState

    func newState(state: AppState, updatedSubstates: Set<PartialKeyPath<AppState>>) {
        presentViews(state)
        processLinkPayload(state)
    }

    private func presentViews(_ state: AppState) {
        let appCopyContent = state.appCopyContentState.copyContent
        let viewModel = SettingsViewModel(searchPreferencesState: state.searchPreferencesState,
                                          measurementFormatter: measurementFormatter,
                                          appCopyContent: appCopyContent)
        presenter.loadSettingsView(viewModel,
                                   appSkin: state.appSkinState.currentValue,
                                   appCopyContent: appCopyContent)
    }

    private func processLinkPayload(_ state: AppState) {
        clearPayloadTypeIfPresent(SettingsLinkPayload.self,
                                  state: state,
                                  store: store)
    }

}
