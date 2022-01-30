//
//  AppCoordinator.swift
//  PlacesFinder
//
//  Copyright (c) 2018 Justin Peckner
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
        let immediateDescendent = type(of: childCoordinator).appCoordinatorImmediateDescendent
        store.dispatch(setCurrentCoordinatorAction(immediateDescendent))

        childCoordinator.start {
            mainWindow.rootViewController = childCoordinator.rootViewController
        }
    }

}

extension AppCoordinator: AppRouterProtocol {

    func createSubtree(from currentNode: NodeBox,
                       towards destinationDescendent: AppCoordinatorDestinationDescendent,
                       state: AppState) {
        childCoordinator = childFactory.buildCoordinator(for: destinationDescendent)
    }

    func switchSubtree(from currentNode: AppCoordinatorDescendent,
                       towards destinationDescendent: AppCoordinatorDestinationDescendent,
                       state: AppState) {
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

        // Don't dispatch .setDestinationCoordinator here, but rather in dispatchDestinationForLinkType() below.
        // Otherwise, we could switch to another child coordinator before LaunchCoordinator has finished app launch.
        store.dispatch(requestLinkTypeAction(appLinkType))

        return true
    }

}

extension AppCoordinator: SubstatesSubscriber {

    typealias StoreState = AppState

    func newState(state: AppState, updatedSubstates: Set<PartialKeyPath<AppState>>) {
        dispatchDestinationForLinkType(state)

        let routingHandler = childFactory.serviceContainer.appRoutingHandler
        routingHandler.determineRouting(state,
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
