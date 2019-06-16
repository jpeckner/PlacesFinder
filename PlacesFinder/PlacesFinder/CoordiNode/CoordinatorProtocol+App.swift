//
//  CoordinatorProtocol+App.swift
//  PlacesFinder
//
//  Created by Justin Peckner.
//  Copyright © 2019 Justin Peckner. All rights reserved.
//

import CoordiNode
import SwiftDux

typealias AppRouterAction = RouterAction<AppLinkType>

extension CoordinatorProtocol {

    func isCurrentCoordinator(_ state: AppState) -> Bool {
        return state.routerState.currentNode == Self.nodeBox
    }

    func requestLinkTypeAction(_ linkType: AppLinkType) -> Action? {
        guard linkType.destinationNodeBox.storedType.nodeBox != Self.nodeBox else { return nil }

        return AppRouterAction.requestLink(linkType)
    }

}

extension DestinationCoordinatorProtocol {

    @discardableResult
    func clearPayloadTypeIfPresent<T: AppLinkPayloadProtocol>(_ payloadType: T.Type,
                                                              state: AppState,
                                                              store: DispatchingStoreProtocol) -> T? {
        guard case let .waitingForPayloadToBeCleared(payload) = state.routerState.loadState,
            let payloadAsT = payload.value as? T
        else { return nil }

        store.dispatch(AppRouterAction.clearLink)
        return payloadAsT
    }

}
