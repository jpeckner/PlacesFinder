//
//  SettingsChildCoordinator.swift
//  PlacesFinder
//
//  Copyright (c) 2022 Justin Peckner
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
import Shared
import SwiftDux
import UIKit

// sourcery: enumCaseName = "settingsChild"
struct SettingsChildLinkPayload: AppLinkPayloadProtocol, Equatable {}

// sourcery: linkPayloadType = "SettingsChildLinkPayload"
class SettingsChildCoordinator<TStore: StoreProtocol> where TStore.TAction == AppAction, TStore.TState == AppState {

    private let store: TStore
    private let viewController: SettingsChildViewController

    private let dismissalSubject: PassthroughSubject<Void, Never>

    @MainActor
    init(store: TStore,
         state: AppState) {
        let dismissalSubject = PassthroughSubject<Void, Never>()

        self.store = store

        let viewModel = SettingsChildViewModel(
            infoViewModel: state.appCopyContentState.copyContent.settingsChildView.staticInfoViewModel,
            ctaTitle: state.appCopyContentState.copyContent.settingsChildView.ctaTitle
        ) {
            dismissalSubject.send()
        }
        self.viewController = SettingsChildViewController(
            viewModel: viewModel,
            colorings: state.appSkinState.currentValue.colorings.settingsChild
        )

        self.dismissalSubject = dismissalSubject

        store.subscribe(self, keyPath: \.routerState)
        viewController.delegate = self
    }

}

extension SettingsChildCoordinator {

    var rootViewController: UIViewController { viewController }

    var dismissal: AnyPublisher<Void, Never> { dismissalSubject.eraseToAnyPublisher() }

}

extension SettingsChildCoordinator: SettingsChildViewControllerDelegate {

    func viewControllerWasDismissed(_ viewController: SettingsChildViewController) {
        dismissalSubject.send()
    }

}

extension SettingsChildCoordinator: SubstatesSubscriber {

    typealias StoreState = AppState

    func newState(state: AppState, updatedSubstates: Set<PartialKeyPath<AppState>>) {
        clearAllAssociatedLinkTypes(state,
                                    store: store)
    }

}
