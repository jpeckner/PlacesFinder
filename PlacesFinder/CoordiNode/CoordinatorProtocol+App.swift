//
//  CoordinatorProtocol+App.swift
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
