//
//  SettingsCoordinator.swift
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

import CoordiNode
import SwiftDux
import UIKit

// sourcery: linkPayloadType = "SettingsLinkPayload"
class SettingsCoordinator<TStore: StoreProtocol> where TStore.State == AppState {

    private let store: TStore
    private let presenter: SettingsPresenterProtocol
    private let settingsViewModelBuilder: SettingsViewModelBuilderProtocol
    private let navigationBarViewModelBuilder: NavigationBarViewModelBuilderProtocol

    init(store: TStore,
         presenter: SettingsPresenterProtocol,
         settingsViewModelBuilder: SettingsViewModelBuilderProtocol,
         navigationBarViewModelBuilder: NavigationBarViewModelBuilderProtocol) {
        self.store = store
        self.presenter = presenter
        self.settingsViewModelBuilder = settingsViewModelBuilder
        self.navigationBarViewModelBuilder = navigationBarViewModelBuilder

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
        let viewModel = settingsViewModelBuilder.buildViewModel(searchPreferencesState: state.searchPreferencesState,
                                                                appCopyContent: appCopyContent)
        let titleViewModel = navigationBarViewModelBuilder.buildTitleViewModel(copyContent: appCopyContent.displayName)

        presenter.loadSettingsView(viewModel,
                                   titleViewModel: titleViewModel,
                                   appSkin: state.appSkinState.currentValue)
    }

    private func processLinkPayload(_ state: AppState) {
        clearPayloadTypeIfPresent(SettingsLinkPayload.self,
                                  state: state,
                                  store: store)
    }

}
