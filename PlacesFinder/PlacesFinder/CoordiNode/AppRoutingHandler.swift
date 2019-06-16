//
//  AppRoutingHandler.swift
//  PlacesFinder
//
//  Created by Justin Peckner.
//  Copyright © 2019 Justin Peckner. All rights reserved.
//

import CoordiNode

protocol AppRoutingHandlerProtocol {
    func handleRouting<TRouter: RouterProtocol>(_ state: AppState,
                                                updatedSubstates: Set<PartialKeyPath<AppState>>,
                                                router: TRouter)
}

class AppRoutingHandler: AppRoutingHandlerProtocol {

    private let routingHandler: RoutingHandlerProtocol

    init(routingHandler: RoutingHandlerProtocol) {
        self.routingHandler = routingHandler
    }

    func handleRouting<TRouter: RouterProtocol>(_ state: AppState,
                                                updatedSubstates: Set<PartialKeyPath<AppState>>,
                                                router: TRouter) {
        guard updatedSubstates.contains(\AppState.routerState),
            let destinationNodeBox = state.routerState.destinationNodeBox,
            let destinationDescendent = TRouter.TDestinationDescendent(destinationNodeBox: destinationNodeBox)
        else { return }

        routingHandler.handleRouting(from: state.routerState.currentNode,
                                     to: destinationDescendent,
                                     for: router)
    }

}
