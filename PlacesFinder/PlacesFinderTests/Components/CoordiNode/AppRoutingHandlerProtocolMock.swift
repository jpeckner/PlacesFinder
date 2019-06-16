//
//  AppRoutingHandlerProtocolMock.swift
//  PlacesFinderTests
//
//  Created by Justin Peckner.
//  Copyright © 2019 Justin Peckner. All rights reserved.
//

import CoordiNode
#if DEBUG
@testable import PlacesFinder
#endif

// swiftlint:disable identifier_name
// swiftlint:disable large_tuple
// swiftlint:disable line_length
internal class AppRoutingHandlerProtocolMock: AppRoutingHandlerProtocol {

    // MARK: - handleRouting<TRouter: RouterProtocol>

    internal var handleRoutingUpdatedSubstatesRouterCallsCount = 0
    internal var handleRoutingUpdatedSubstatesRouterCalled: Bool {
        return handleRoutingUpdatedSubstatesRouterCallsCount > 0
    }
    internal var handleRoutingUpdatedSubstatesRouterReceivedArguments: (state: AppState, updatedSubstates: Set<PartialKeyPath<AppState>>, router: CoordinatorProtocol)?
    internal var handleRoutingUpdatedSubstatesRouterClosure: ((AppState, Set<PartialKeyPath<AppState>>, CoordinatorProtocol) -> Void)?

    internal func handleRouting<TRouter: RouterProtocol>(_ state: AppState,
                                                         updatedSubstates: Set<PartialKeyPath<AppState>>,
                                                         router: TRouter) {
        handleRoutingUpdatedSubstatesRouterCallsCount += 1
        handleRoutingUpdatedSubstatesRouterReceivedArguments = (state: state, updatedSubstates: updatedSubstates, router: router)
        handleRoutingUpdatedSubstatesRouterClosure?(state, updatedSubstates, router)
    }

}
