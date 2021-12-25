//
//  LaunchCoordinator.swift
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

class LaunchCoordinator<TStore: StoreProtocol> where TStore.State == AppState {

    private let store: TStore
    private let presenter: LaunchPresenterProtocol
    private let listenerContainer: ListenerContainer
    private let serviceContainer: ServiceContainer
    private let statePrism: LaunchStatePrismProtocol
    private let stylingsHandler: AppGlobalStylingsHandlerProtocol
    private let defaultLinkType: AppLinkType
    private let appSkinActionCreator: AppSkinActionCreatorProtocol.Type

    init(store: TStore,
         presenter: LaunchPresenterProtocol,
         listenerContainer: ListenerContainer,
         serviceContainer: ServiceContainer,
         statePrism: LaunchStatePrismProtocol,
         stylingsHandler: AppGlobalStylingsHandlerProtocol,
         defaultLinkType: AppLinkType,
         appSkinActionCreator: AppSkinActionCreatorProtocol.Type = AppSkinActionCreator.self) {
        self.store = store
        self.listenerContainer = listenerContainer
        self.serviceContainer = serviceContainer
        self.presenter = presenter
        self.statePrism = statePrism
        self.stylingsHandler = stylingsHandler
        self.defaultLinkType = defaultLinkType
        self.appSkinActionCreator = appSkinActionCreator
    }

}

extension LaunchCoordinator: ChildCoordinatorProtocol {

    var rootViewController: UIViewController {
        return presenter.rootViewController
    }

    // MARK: start()

    func start(_ completion: () -> Void) {
        presenter.startSpinner()

        subscribeAndDispatchActions()
        startListeners()

        completion()
    }

    private func subscribeAndDispatchActions() {
        store.subscribe(self, equatableKeyPaths: statePrism.launchKeyPaths)
        store.dispatch(appSkinActionCreator.loadSkin(skinService: serviceContainer.appSkinService))
    }

    private func startListeners() {
        listenerContainer.locationAuthListener.start()
        AssertionHandler.assertIfErrorThrown { try listenerContainer.reachabilityListener?.start() }
        listenerContainer.userDefaultsListener.start()
    }

    // MARK: finish()

    func finish(_ completion: (() -> Void)?) {
        store.unsubscribe(self)
        presenter.animateOut(completion)
    }

}

extension LaunchCoordinator: SubstatesSubscriber {

    typealias StoreState = AppState

    func newState(state: AppState, updatedSubstates: Set<PartialKeyPath<AppState>>) {
        guard statePrism.hasFinishedLaunching(state) else { return }

        stylingsHandler.apply(state.appSkinState.currentValue)
        requestDefaultLinkTypeIfNeeded(state)
    }

    private func requestDefaultLinkTypeIfNeeded(_ state: AppState) {
        switch state.routerState.loadState {
        case .idle:
            requestLinkTypeAction(defaultLinkType).map(store.dispatch)
        case .payloadRequested,
             .navigatingToDestination,
             .waitingForPayloadToBeCleared:
            break
        }
    }

}
