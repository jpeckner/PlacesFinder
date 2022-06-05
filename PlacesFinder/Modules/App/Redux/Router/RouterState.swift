//
//  RouterState.swift
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
import Foundation
import SwiftDux

struct RouterState<TLinkType: RouterLinkType>: Equatable {
    enum LoadState: Equatable {
        case idle
        case payloadRequested(TLinkType)
        case navigatingToDestination(DestinationNodeBox, linkType: TLinkType?)
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

    static func reduce(action: AppAction,
                       currentState: RouterState<TLinkType>) -> RouterState<TLinkType> {
        guard case let .router(wrappedRouterAction) = action,
              let routerAction = wrappedRouterAction as? RouterAction<TLinkType>
        else {
            return currentState
        }

        return reduce(routerAction: routerAction,
                      currentState: currentState)
    }

    static func reduce(routerAction: RouterAction<TLinkType>,
                       currentState: RouterState<TLinkType>) -> RouterState<TLinkType> {
        switch routerAction {
        case let .setCurrentCoordinator(updatedCurrentNode):
            return RouterState(loadState: loadStateForSetCurrent(updatedCurrentNode, currentState: currentState),
                               currentNode: updatedCurrentNode)
        case let .setDestinationCoordinator(destinationNodeBox, linkType):
            return RouterState(loadState: .navigatingToDestination(destinationNodeBox, linkType: linkType),
                               currentNode: currentState.currentNode)
        case let .requestLink(linkType):
            let isLinkForCurrentNode = currentState.currentNode == linkType.destinationNodeBox.storedType.nodeBox
            return RouterState(
                loadState: isLinkForCurrentNode ? .waitingForPayloadToBeCleared(linkType) : .payloadRequested(linkType),
                currentNode: currentState.currentNode
            )
        case .clearLink:
            return RouterState(loadState: .idle,
                               currentNode: currentState.currentNode)
        }
    }

    private static func loadStateForSetCurrent(
        _ updatedCurrentNode: NodeBox,
        currentState: RouterState<TLinkType>
    ) -> RouterState<TLinkType>.LoadState {
        switch currentState.loadState {
        case .idle,
             .payloadRequested,
             .waitingForPayloadToBeCleared:
            return currentState.loadState
        case let .navigatingToDestination(destinationNodeBox, linkType):
            guard destinationNodeBox.storedType.nodeBox == updatedCurrentNode else {
                return currentState.loadState
            }

            guard let linkType = linkType else {
                return .idle
            }

            return .waitingForPayloadToBeCleared(linkType)
        }
    }

}
