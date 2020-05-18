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

    func currentNavigatingToDestinationPayload<T: AppLinkPayloadProtocol>(_ payloadType: T.Type,
                                                                          state: AppState) -> T? {
        switch state.routerState.loadState {
        case let .navigatingToDestination(_, linkType):
            return linkType?.value as? T
        case .idle,
             .payloadRequested,
             .waitingForPayloadToBeCleared:
            return nil
        }
    }

    func currentPayloadToBeCleared<T: AppLinkPayloadProtocol>(_ payloadType: T.Type,
                                                              state: AppState) -> T? {
        switch state.routerState.loadState {
        case let .waitingForPayloadToBeCleared(linkType):
            return linkType.value as? T
        case .idle,
             .navigatingToDestination,
             .payloadRequested:
            return nil
        }
    }

    @discardableResult
    func clearPayloadTypeIfPresent<TPayload: AppLinkPayloadProtocol>(_ payloadType: TPayload.Type,
                                                                     state: AppState,
                                                                     store: DispatchingStoreProtocol) -> TPayload? {
        guard let payload = currentPayloadToBeCleared(payloadType, state: state) else {
            return nil
        }

        store.dispatch(AppRouterAction.clearLink)
        return payload
    }

}
