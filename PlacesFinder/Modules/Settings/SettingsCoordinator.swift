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

import Combine
import CoordiNode
import Shared
import SwiftDux
import UIKit

// sourcery: linkPayloadType = "SettingsLinkPayload"
@MainActor class SettingsCoordinator<TStore: StoreProtocol>
    where TStore.TAction == AppAction, TStore.TState == AppState {

    private let store: TStore
    private let presenter: SettingsPresenterProtocol
    private let serviceContainer: ServiceContainer
    private let settingsViewModelBuilder: SettingsViewModelBuilderProtocol
    private let navigationBarViewModelBuilder: NavigationBarViewModelBuilderProtocol

    private let aboutAppDisposedSubject = PassthroughSubject<Void, Never>()
    private var aboutAppDismissalActions: Set<AnyCancellable> = []

    private var child: Child? {
        didSet {
            guard oldValue != child else {
                return
            }

            handleChildDidSet()
        }
    }

    init(store: TStore,
         presenter: SettingsPresenterProtocol,
         serviceContainer: ServiceContainer,
         settingsViewModelBuilder: SettingsViewModelBuilderProtocol,
         navigationBarViewModelBuilder: NavigationBarViewModelBuilderProtocol) {
        self.store = store
        self.presenter = presenter
        self.serviceContainer = serviceContainer
        self.settingsViewModelBuilder = settingsViewModelBuilder
        self.navigationBarViewModelBuilder = navigationBarViewModelBuilder

        store.subscribe(self, equatableKeyPaths: [
            EquatableKeyPath(\AppState.routerState),
            EquatableKeyPath(\AppState.searchPreferencesState)
        ])
    }

}

extension SettingsCoordinator: TabCoordinatorProtocol {

    var rootViewController: UIViewController {
        return presenter.rootNavController
    }

    func relinquishActive(completion: (() -> Void)?) {
        switch child {
        case .aboutApp:
            // AboutApp has a modal that presents over the tab bar, so it needs to be dismissed here before
            // switching to another coordinator that's at/above SettingsCoordinator
            aboutAppDismissalActions.removeAll()
            aboutAppDisposedSubject
                .sink {
                    completion?()
                }
                .store(in: &aboutAppDismissalActions)

            child = nil
        case .none:
            completion?()
        }
    }

}

extension SettingsCoordinator: AppDestinationRouterProtocol {

    func createSubtree(from currentNode: NodeBox,
                       towards destinationDescendent: SettingsCoordinatorDestinationDescendent,
                       state: AppState) {
        switch destinationDescendent {
        case .aboutApp:
            // Don't present the modal until this tab is actually visible; otherwise, it's been observed that the modal
            // doesn't dispatch callbacks as expected upon dismissal
            guard state.routerState.isSettingsActive else {
                return
            }

            child = .aboutApp(IgnoredEquatable(
                AboutAppCoordinator(
                    store: store,
                    state: state,
                    skin: state.appSkinState.currentValue,
                    appDisplayName: serviceContainer.appBundleInfo.displayName,
                    appVersion: serviceContainer.appBundleInfo.version
                )
            ))
        }
    }

    func switchSubtree(from currentNode: SettingsCoordinatorDescendent,
                       towards destinationDescendent: SettingsCoordinatorDestinationDescendent,
                       state: AppState) {
        createSubtree(from: currentNode.nodeBox,
                      towards: destinationDescendent,
                      state: state)
    }

    func closeAllSubtrees(currentNode: NodeBox,
                          state: AppState) {
        aboutAppDismissalActions.removeAll()
        aboutAppDisposedSubject
            .sink { [weak self] in
                guard let self = self else { return }
                self.store.dispatch(self.setSelfAsCurrentCoordinator)
            }
            .store(in: &aboutAppDismissalActions)

        child = nil
    }

}

extension SettingsCoordinator: SubstatesSubscriber {

    typealias StoreState = AppState

    nonisolated func newState(state: AppState,
                              updatedSubstates: Set<PartialKeyPath<AppState>>) {
        let updatedRoutingSubstates = UpdatedRoutingSubstates(updatedSubstates: updatedSubstates)

        Task { @MainActor in
            presentViews(state,
                         updatedRoutingSubstates: updatedRoutingSubstates)

            processLinkPayload(state)
        }
    }

    private func presentViews(_ state: AppState,
                              updatedRoutingSubstates: UpdatedRoutingSubstates) {
        let appCopyContent = state.appCopyContentState.copyContent
        let appSkin = state.appSkinState.currentValue

        let viewModel = settingsViewModelBuilder.buildViewModel(
            searchPreferencesState: state.searchPreferencesState,
            appCopyContent: appCopyContent,
            appDisplayName: serviceContainer.appBundleInfo.displayName,
            colorings: appSkin.colorings.settings
        )
        let titleViewModel = navigationBarViewModelBuilder.buildTitleViewModel(copyContent: appCopyContent.displayName)
        presenter.loadSettingsView(viewModel,
                                   titleViewModel: titleViewModel,
                                   appSkin: appSkin)

        serviceContainer.appRoutingHandler.determineRouting(state: state,
                                                            updatedRoutingSubstates: updatedRoutingSubstates,
                                                            router: self)
    }

    private func processLinkPayload(_ state: AppState) {
        clearAllAssociatedLinkTypes(state,
                                    store: store)
    }

}

// MARK: - Private SettingsCoordinator extensions

private extension SettingsCoordinator {

    enum Child: Equatable {
        case aboutApp(IgnoredEquatable<AboutAppCoordinator<TStore>>)
    }

}

private extension SettingsCoordinator {

    func handleChildDidSet() {
        switch child {
        case let .aboutApp(coordinator):
            presenter.rootNavController.present(coordinator.value.rootViewController, animated: true) { [weak self] in
                self?.handleAboutAppPresentation(coordinator: coordinator.value)
            }
        case .none:
            presenter.rootNavController.dismiss(animated: true) { [weak self] in
                self?.aboutAppDisposedSubject.send()
            }
        }
    }

    private func handleAboutAppPresentation(coordinator: AboutAppCoordinator<TStore>) {
        let immediateDescendent = SettingsCoordinatorImmediateDescendent.aboutApp
        store.dispatch(setCurrentCoordinatorAction(immediateDescendent))

        aboutAppDismissalActions.removeAll()
        coordinator.dismissal
            .sink { [weak self] in
                guard let self = self else { return }

                self.child = nil
                self.store.dispatch(self.setSelfAsCurrentCoordinator)
            }
            .store(in: &aboutAppDismissalActions)
    }

}

// MARK: - Private RouterState extension

private extension RouterState {

    var isSettingsActive: Bool {
        return
            currentNode == SettingsCoordinatorNode.nodeBox
            || SettingsCoordinatorDescendent(nodeBox: currentNode) != nil
    }

}
