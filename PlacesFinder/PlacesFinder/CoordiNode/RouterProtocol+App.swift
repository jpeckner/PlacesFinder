//
//  RouterProtocol+App.swift
//  PlacesFinder
//
//  Created by Justin Peckner.
//  Copyright © 2019 Justin Peckner. All rights reserved.
//

import CoordiNode
import SwiftDux

extension RouterProtocol {

    func setCurrentCoordinatorAction(_ immediateDescendent: TDescendent.TImmediateDescendent) -> Action {
        return AppRouterAction.setCurrentCoordinator(immediateDescendent.nodeBox)
    }

}

extension RootCoordinatorProtocol {

    // Only the RootCoordinatorProtocol, which controls the entire app, can dispatch setDestinationCoordinator in
    // response to link payloads being requested. Otherwise, any coordinator could effectively steer the app to any
    // other, which would negate the purpose of CoordiNode's routing system.
    func setLinkDestinationAction(_ state: AppState) -> Action? {
        guard case let .payloadRequested(linkType) = state.routerState.loadState else { return nil }

        return AppRouterAction.setDestinationCoordinator(linkType.destinationNodeBox,
                                                         payload: linkType)
    }

}
