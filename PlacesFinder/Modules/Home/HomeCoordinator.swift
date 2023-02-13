//
//  HomeCoordinator.swift
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
import Shared
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

    func start() {
        store.subscribe(self, keyPath: \AppState.routerState)
    }

    func finish() async {
        store.unsubscribe(self)
    }

}

extension HomeCoordinator: AppRouterProtocol {

    func createSubtree(from currentNode: NodeBox,
                       towards destinationDescendent: HomeCoordinatorDestinationDescendent,
                       state: AppState) {
        handleNewTabSet(destinationDescendent: destinationDescendent)
    }

    func switchSubtree(from currentNode: HomeCoordinatorDescendent,
                       towards destinationDescendent: HomeCoordinatorDestinationDescendent,
                       state: AppState) {
        let currentCoordinator = childContainer.coordinator(for: currentNode.immediateDescendent)
        currentCoordinator.relinquishActive { [weak self] in
            self?.createSubtree(from: currentNode.nodeBox,
                                towards: destinationDescendent,
                                state: state)
        }
    }

    private func handleNewTabSet(destinationDescendent: HomeCoordinatorDestinationDescendent) {
        let immediateDescendent =
            HomeCoordinatorDescendent(destinationDescendent: destinationDescendent).immediateDescendent
        let childCoordinator = childContainer.coordinator(for: immediateDescendent)

        store.dispatch(setCurrentCoordinatorAction(immediateDescendent))
        presenter.setSelectedViewController(childCoordinator.rootViewController)
    }

}

extension HomeCoordinator: HomePresenterDelegate {

    func homePresenter(_ homePresenter: HomePresenterProtocol,
                       didSelectChildCoordinator index: Int) {
        handleNewTabSet(destinationDescendent: HomeCoordinatorDestinationDescendent.allCases[index])
    }

}

extension HomeCoordinator: SubstatesSubscriber {

    typealias StoreState = AppState

    func newState(state: AppState, updatedSubstates: Set<PartialKeyPath<AppState>>) {
        appRoutingHandler.determineRouting(state,
                                           updatedSubstates: updatedSubstates,
                                           router: self)
    }

}
