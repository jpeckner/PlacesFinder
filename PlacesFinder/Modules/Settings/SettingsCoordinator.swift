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
class SettingsCoordinator<TStore: StoreProtocol> where TStore.TAction == AppAction, TStore.TState == AppState {

    private let store: TStore
    private let presenter: SettingsPresenterProtocol
    private let serviceContainer: ServiceContainer
    private let settingsViewModelBuilder: SettingsViewModelBuilderProtocol
    private let navigationBarViewModelBuilder: NavigationBarViewModelBuilderProtocol

    private let settingsChildDisposedSubject = PassthroughSubject<Void, Never>()
    private var settingsChildDismissalActions: Set<AnyCancellable> = []

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
        case .settingsChild:
            settingsChildDismissalActions.removeAll()
            settingsChildDisposedSubject
                .sink {
                    completion?()
                }
                .store(in: &settingsChildDismissalActions)

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
        case .settingsChild:
            // Don't present the modal until this tab is actually visible; otherwise, it's been observed that the modal
            // doesn't dispatch callbacks as expected upon dismissal
            guard state.routerState.isSettingsActive else {
                return
            }

            child = .settingsChild(IgnoredEquatable(SettingsChildCoordinator(store: store,
                                                                             state: state)))
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
        settingsChildDismissalActions.removeAll()
        settingsChildDisposedSubject
            .sink { [weak self] in
                guard let self = self else { return }
                self.store.dispatch(self.setSelfAsCurrentCoordinator)
            }
            .store(in: &settingsChildDismissalActions)

        child = nil
    }

}

extension SettingsCoordinator: SubstatesSubscriber {

    typealias StoreState = AppState

    func newState(state: AppState, updatedSubstates: Set<PartialKeyPath<AppState>>) {
        presentViews(state,
                     updatedSubstates: updatedSubstates)

        processLinkPayload(state)
    }

    private func presentViews(_ state: AppState,
                              updatedSubstates: Set<PartialKeyPath<AppState>>) {
        let appCopyContent = state.appCopyContentState.copyContent
        let viewModel = settingsViewModelBuilder.buildViewModel(
            searchPreferencesState: state.searchPreferencesState,
            appCopyContent: appCopyContent,
            settingsChildRequestAction: requestLinkTypeAction(.settingsChild(SettingsChildLinkPayload()))
        )
        let titleViewModel = navigationBarViewModelBuilder.buildTitleViewModel(copyContent: appCopyContent.displayName)
        presenter.loadSettingsView(viewModel,
                                   titleViewModel: titleViewModel,
                                   appSkin: state.appSkinState.currentValue)

        serviceContainer.appRoutingHandler.determineRouting(state,
                                                            updatedSubstates: updatedSubstates,
                                                            router: self)
    }

    private func processLinkPayload(_ state: AppState) {
        clearAllAssociatedLinkTypes(state,
                                    store: store)
    }

}

private extension SettingsCoordinator {

    enum Child: Equatable {
        case settingsChild(IgnoredEquatable<SettingsChildCoordinator<TStore>>)
    }

}

private extension SettingsCoordinator {

    func handleChildDidSet() {
        switch child {
        case let .settingsChild(coordinator):
            presenter.rootNavController.present(coordinator.value.rootViewController, animated: true) { [weak self] in
                self?.handleSettingsChildPresentation(coordinator: coordinator.value)
            }
        case .none:
            presenter.rootNavController.dismiss(animated: true) { [weak self] in
                self?.settingsChildDisposedSubject.send()
            }
        }
    }

    private func handleSettingsChildPresentation(coordinator: SettingsChildCoordinator<TStore>) {
        let immediateDescendent = SettingsCoordinatorImmediateDescendent.settingsChild
        store.dispatch(setCurrentCoordinatorAction(immediateDescendent))

        settingsChildDismissalActions.removeAll()
        coordinator.dismissal
            .sink { [weak self] in
                guard let self = self else { return }

                self.child = nil
                self.store.dispatch(self.setSelfAsCurrentCoordinator)
            }
            .store(in: &settingsChildDismissalActions)
    }

}

private extension RouterState {

    var isSettingsActive: Bool {
        return
            currentNode == SettingsCoordinatorNode.nodeBox
            || SettingsCoordinatorDescendent(nodeBox: currentNode) != nil
    }

}
