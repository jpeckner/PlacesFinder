//
//  PayloadConsumingCoordinatorProtocol.swift
//  PlacesFinder
//
//  Copyright (c) 2023 Justin Peckner
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

protocol CoordinatorPayload {
    init?(appLinkPayload: AppLinkPayloadProtocol)
}

protocol PayloadConsumingCoordinatorProtocol: CoordinatorProtocol {
    associatedtype TPayload: CoordinatorPayload
}

extension PayloadConsumingCoordinatorProtocol {

    @discardableResult
    func clearPayloadIfCurrentCoordinator<TStore: DispatchingStoreProtocol>(
        state: AppState,
        store: TStore
    ) -> TPayload? where TStore.TAction == AppAction {
        guard isCurrentCoordinator(state: state),
              let payload = extractPayload(state: state)
        else {
            return nil
        }

        store.dispatch(.router(.clearLink))

        return payload
    }

    private func extractPayload(
        state: AppState
    ) -> TPayload? {
        switch state.routerState.loadState {
        case let .navigatingToDestination(destinationNodeBox, linkType):
            guard Self.nodeBox == destinationNodeBox.asNodeBox,
                  let appLinkPayload = linkType?.value,
                  let coordinatorPayload = TPayload(appLinkPayload: appLinkPayload)
            else {
                return nil
            }

            return coordinatorPayload

        case .idle,
             .payloadRequested:
            return nil
        }
    }

}
