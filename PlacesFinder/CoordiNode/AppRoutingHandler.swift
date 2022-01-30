//
//  AppRoutingHandler.swift
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

protocol AppRoutingHandlerProtocol {
    func determineRouting<TRouter: AppRouterProtocol>(_ state: AppState,
                                                      updatedSubstates: Set<PartialKeyPath<AppState>>,
                                                      router: TRouter)

    func determineRouting<TRouter: AppDestinationRouterProtocol>(_ state: AppState,
                                                                 updatedSubstates: Set<PartialKeyPath<AppState>>,
                                                                 router: TRouter)
}

class AppRoutingHandler: AppRoutingHandlerProtocol {

    private let routingHandler: RoutingHandlerProtocol
    private let destinationRoutingHandler: DestinationRoutingHandlerProtocol

    init(routingHandler: RoutingHandlerProtocol,
         destinationRoutingHandler: DestinationRoutingHandlerProtocol) {
        self.routingHandler = routingHandler
        self.destinationRoutingHandler = destinationRoutingHandler
    }

    func determineRouting<TRouter: AppRouterProtocol>(_ state: AppState,
                                                      updatedSubstates: Set<PartialKeyPath<AppState>>,
                                                      router: TRouter) {
        guard updatedSubstates.contains(\AppState.routerState),
              let destinationNodeBox = state.routerState.destinationNodeBox,
              let destinationDescendent = TRouter.TDestinationDescendent(destinationNodeBox: destinationNodeBox)
        else { return }

        let result = routingHandler.determineRouting(from: state.routerState.currentNode,
                                                     to: destinationDescendent,
                                                     for: router)
        switch result {
        case let .createSubtree(currentNode, destinationDescendent):
            router.createSubtree(from: currentNode,
                                 towards: destinationDescendent,
                                 state: state)
        case let .switchSubtree(currentNode, destinationDescendent):
            router.switchSubtree(from: currentNode,
                                 towards: destinationDescendent,
                                 state: state)
        case .none:
            break
        }
    }

    func determineRouting<TRouter: AppDestinationRouterProtocol>(_ state: AppState,
                                                                 updatedSubstates: Set<PartialKeyPath<AppState>>,
                                                                 router: TRouter) {
        guard updatedSubstates.contains(\AppState.routerState),
              let destinationNodeBox = state.routerState.destinationNodeBox
        else { return }

        let result = destinationRoutingHandler.determineRouting(from: state.routerState.currentNode,
                                                                to: destinationNodeBox,
                                                                for: router)
        switch result {
        case let .createSubtree(currentNode, destinationDescendent):
            router.createSubtree(from: currentNode,
                                 towards: destinationDescendent,
                                 state: state)
        case let .switchSubtree(currentNode, destinationDescendent):
            router.switchSubtree(from: currentNode,
                                 towards: destinationDescendent,
                                 state: state)
        case let .closeAllSubtrees(currentNode):
            router.closeAllSubtrees(currentNode: currentNode,
                                    state: state)
        case .none:
            break
        }
    }

}
