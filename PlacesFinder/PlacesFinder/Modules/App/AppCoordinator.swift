//
//  AppCoordinator.swift
//  PlacesFinder
//
//  Created by Justin Peckner.
//  Copyright © 2018 Justin Peckner. All rights reserved.
//

import CoordiNode
import Foundation
import Shared
import SwiftDux

class AppCoordinator<TFactory: AppCoordinatorChildFactoryProtocol> {

    private let mainWindow: UIWindowProtocol
    private let childFactory: TFactory
    private let payloadBuilder: AppLinkTypeBuilderProtocol
    private var childCoordinator: AppCoordinatorChildProtocol {
        didSet {
            didSetChildCoordinator()
        }
    }

    private var store: TFactory.TStore {
        return childFactory.store
    }

    init(mainWindow: UIWindowProtocol,
         childFactory: TFactory,
         payloadBuilder: AppLinkTypeBuilderProtocol) {
        self.mainWindow = mainWindow
        self.childFactory = childFactory
        self.payloadBuilder = payloadBuilder
        self.childCoordinator = childFactory.buildLaunchCoordinator()
    }

}

extension AppCoordinator {

    func start() {
        didSetChildCoordinator()

        let keyPaths = childFactory.launchStatePrism.launchKeyPaths.union([
            EquatableKeyPath(\AppState.routerState),
        ])
        store.subscribe(self, equatableKeyPaths: keyPaths)
    }

    private func didSetChildCoordinator() {
        store.dispatch(setCurrentCoordinatorAction(type(of: childCoordinator).appCoordinatorImmediateDescendent))

        childCoordinator.start {
            mainWindow.rootViewController = childCoordinator.rootViewController
        }
    }

}

extension AppCoordinator {

    func createSubtree(towards destinationDescendent: AppCoordinatorDestinationDescendent) {
        childCoordinator = childFactory.buildCoordinator(for: destinationDescendent)
    }

    func switchSubtree(from currentDescendent: AppCoordinatorDescendent,
                       to destinationDescendent: AppCoordinatorDestinationDescendent) {
        // Build the new child coordinator here, not inside finish(), to avoid a split-second empty view flash
        let newChildCoordinator = childFactory.buildCoordinator(for: destinationDescendent)

        childCoordinator.finish { [weak self] in
            self?.childCoordinator = newChildCoordinator
        }
    }

}

extension AppCoordinator {

    func handleURL(_ url: URL) -> Bool {
        guard let appLinkType = payloadBuilder.buildPayload(url) else { return false }

        // Don't dispatch .setDestinationCoordinator here; that needs to be done by setDestinationForLinkType() below.
        // Otherwise, we could switch to another child coordinator before LaunchCoordinator has finished app launch.
        requestLinkTypeAction(appLinkType).map(store.dispatch)

        return true
    }

}

extension AppCoordinator: SubstatesSubscriber {

    typealias StoreState = AppState

    func newState(state: AppState, updatedSubstates: Set<PartialKeyPath<AppState>>) {
        dispatchDestinationForLinkType(state)

        let routingHandler = childFactory.serviceContainer.appRoutingHandler
        routingHandler.handleRouting(state,
                                     updatedSubstates: updatedSubstates,
                                     router: self)
    }

    private func dispatchDestinationForLinkType(_ state: AppState) {
        guard childFactory.launchStatePrism.hasFinishedLaunching(state),
            let action = setLinkDestinationAction(state)
        else { return }

        store.dispatch(action)
    }

}
