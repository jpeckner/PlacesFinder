//
//  LaunchCoordinator.swift
//  PlacesFinder
//
//  Created by Justin Peckner.
//  Copyright © 2019 Justin Peckner. All rights reserved.
//

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
