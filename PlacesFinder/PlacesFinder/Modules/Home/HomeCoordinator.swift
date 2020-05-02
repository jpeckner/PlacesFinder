//
//  HomeCoordinator.swift
//  PlacesFinder
//
//  Created by Justin Peckner.
//  Copyright © 2019 Justin Peckner. All rights reserved.
//

import CoordiNode
import SwiftDux
import UIKit

class HomeCoordinator<TFactory: HomeCoordinatorChildFactoryProtocol> {

    private let store: TFactory.TStore
    private let childContainer: HomeCoordinatorChildContainer<TFactory>
    private let presenter: HomePresenterProtocol
    private let appRoutingHandler: AppRoutingHandlerProtocol

    init(store: TFactory.TStore,
         childContainer: HomeCoordinatorChildContainer<TFactory>,
         presenter: HomePresenterProtocol,
         appRoutingHandler: AppRoutingHandlerProtocol) {
        self.store = store
        self.childContainer = childContainer
        self.presenter = presenter
        self.appRoutingHandler = appRoutingHandler

        presenter.delegate = self
    }

}

extension HomeCoordinator: ChildCoordinatorProtocol {

    var rootViewController: UIViewController {
        return presenter.rootViewController
    }

    func start(_ completion: () -> Void) {
        store.subscribe(self, keyPath: \AppState.routerState)
        completion()
    }

    func finish(_ completion: (() -> Void)?) {
        store.unsubscribe(self)
        completion?()
    }

}

extension HomeCoordinator {

    func createSubtree(towards destinationDescendent: HomeCoordinatorDestinationDescendent) {
        let immediateDescendent =
            HomeCoordinatorDescendent(destinationDescendent: destinationDescendent).immediateDescendent
        let childCoordinator = childContainer.coordinator(for: immediateDescendent)

        store.dispatch(setCurrentCoordinatorAction(immediateDescendent))
        presenter.setSelectedViewController(childCoordinator.rootViewController)
    }

    func switchSubtree(from currentDescendent: HomeCoordinatorDescendent,
                       to destinationDescendent: HomeCoordinatorDestinationDescendent) {
        createSubtree(towards: destinationDescendent)
    }

}

extension HomeCoordinator: HomeViewControllerDelegate {

    func viewController(_ homeViewController: HomeViewController,
                        didSelectIndex index: Int,
                        previousIndex: Int) {
        switchSubtree(from: HomeCoordinatorDescendent.allCases[previousIndex],
                      to: HomeCoordinatorDestinationDescendent.allCases[index])
    }

}

extension HomeCoordinator: SubstatesSubscriber {

    typealias StoreState = AppState

    func newState(state: AppState, updatedSubstates: Set<PartialKeyPath<AppState>>) {
        appRoutingHandler.handleRouting(state,
                                        updatedSubstates: updatedSubstates,
                                        router: self)
    }

}
