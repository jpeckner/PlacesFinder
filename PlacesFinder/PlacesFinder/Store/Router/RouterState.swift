//
//  RouterState.swift
//  PlacesFinder
//
//  Created by Justin Peckner.
//  Copyright © 2019 Justin Peckner. All rights reserved.
//

import CoordiNode
import Foundation
import SwiftDux

struct RouterState<TLinkType: RouterLinkType>: Equatable {
    enum LoadState: Equatable {
        case idle
        case payloadRequested(TLinkType)
        case navigatingToDestination(DestinationNodeBox, payload: TLinkType?)
        case waitingForPayloadToBeCleared(TLinkType)
    }

    let loadState: LoadState
    let currentNode: NodeBox
}

extension RouterState {

    init(currentNode: NodeBox) {
        self.loadState = .idle
        self.currentNode = currentNode
    }

    var destinationNodeBox: DestinationNodeBox? {
        switch loadState {
        case let .navigatingToDestination(destinationNodeBox, _):
            return destinationNodeBox
        case .idle,
             .payloadRequested,
             .waitingForPayloadToBeCleared:
            return nil
        }
    }

}

enum RouterReducer<TLinkType: RouterLinkType> {

    static func reduce(action: Action,
                       currentState: RouterState<TLinkType>) -> RouterState<TLinkType> {
        guard let routerAction = action as? RouterAction<TLinkType> else { return currentState }

        switch routerAction {
        case let .setCurrentCoordinator(updatedCurrentNode):
            return RouterState(loadState: loadStateAfterUpdating(updatedCurrentNode, currentState: currentState),
                               currentNode: updatedCurrentNode)
        case let .setDestinationCoordinator(destinationNodeBox, payload):
            return RouterState(loadState: .navigatingToDestination(destinationNodeBox, payload: payload),
                               currentNode: currentState.currentNode)
        case let .requestLink(linkType):
            return RouterState(loadState: .payloadRequested(linkType),
                               currentNode: currentState.currentNode)
        case .clearLink:
            return RouterState(loadState: .idle,
                               currentNode: currentState.currentNode)
        }
    }

    private static func loadStateAfterUpdating(
        _ updatedCurrentNode: NodeBox,
        currentState: RouterState<TLinkType>
    ) -> RouterState<TLinkType>.LoadState {
        switch currentState.loadState {
        case .idle,
             .payloadRequested,
             .waitingForPayloadToBeCleared:
            return currentState.loadState
        case let .navigatingToDestination(destinationNodeBox, payload):
            guard destinationNodeBox.storedType.nodeBox == updatedCurrentNode else {
                return currentState.loadState
            }

            guard let payload = payload else {
                return .idle
            }

            return .waitingForPayloadToBeCleared(payload)
        }
    }

}
