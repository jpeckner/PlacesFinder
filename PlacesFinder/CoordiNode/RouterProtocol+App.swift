//  swiftlint:disable:this file_name
//
//  RouterProtocol+App.swift
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

// MARK: AppRouterProtocol

protocol AppRouterProtocol: RouterProtocol {
    // periphery:ignore:parameters currentNode
    @MainActor
    func createSubtree(from currentNode: NodeBox,
                       towards destinationDescendent: TDestinationDescendent,
                       state: AppState)

    @MainActor
    func switchSubtree(from currentNode: TDescendent,
                       towards destinationDescendent: TDestinationDescendent,
                       state: AppState)
}

extension AppRouterProtocol {

    func setCurrentCoordinatorAction(_ immediateDescendent: TDescendent.TImmediateDescendent) -> AppAction {
        return .router(.setCurrentCoordinator(immediateDescendent.nodeBox))
    }

}

// MARK: AppDestinationRouterProtocol

protocol AppDestinationRouterProtocol: AppRouterProtocol, DestinationRouterProtocol {
    // periphery:ignore:parameters currentNode,state
    @MainActor
    func closeAllSubtrees(currentNode: NodeBox,
                          state: AppState)
}

extension AppDestinationRouterProtocol {

    var setSelfAsCurrentCoordinator: AppAction {
        return .router(.setCurrentCoordinator(Self.nodeBox))
    }

}

// MARK: RootCoordinatorProtocol

extension RootCoordinatorProtocol {

    // Coordinators other than the app's top-level coordinator can *request* to route to another coordinator (by using
    // `.payloadRequested`), but it's up to the RootCoordinatorProtocol to decide when and how to actually make
    // the change by dispatching `.setDestinationCoordinator`.
    func setLinkDestinationAction(_ state: AppState) -> AppAction? {
        switch state.routerState.loadState {
        case let .payloadRequested(linkType):
            return .router(.setDestinationCoordinator(linkType.destinationNodeBox,
                                                      payload: linkType))
        case .idle,
             .navigatingToDestination,
             .waitingForPayloadToBeCleared:
            return nil
        }
    }

}
