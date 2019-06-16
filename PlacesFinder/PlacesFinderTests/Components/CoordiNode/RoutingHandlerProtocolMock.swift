//
//  RoutingHandlerProtocolMock.swift
//  PlacesFinderTests
//
//  Created by Justin Peckner.
//  Copyright © 2019 Justin Peckner. All rights reserved.
//

import CoordiNode

// swiftlint:disable large_tuple
internal class RoutingHandlerProtocolMock: RoutingHandlerProtocol {

    init() {}

    // MARK: - handleRouting<TRouter: RouterProtocol>

    internal var handleRoutingFromToForCallsCount = 0
    internal var handleRoutingFromToForCalled: Bool {
        return handleRoutingFromToForCallsCount > 0
    }
    internal var handleRoutingFromToForReceivedArguments: (
        currentNode: NodeBox,
        destinationDescendent: DestinationDescendentProtocol,
        router: CoordinatorProtocol
    )?
    internal var handleRoutingFromToForClosure: ((NodeBox, DestinationDescendentProtocol, CoordinatorProtocol) -> Void)?

    internal func handleRouting<TRouter: RouterProtocol>(from currentNode: NodeBox,
                                                         to destinationDescendent: TRouter.TDestinationDescendent,
                                                         for router: TRouter) {
        handleRoutingFromToForCallsCount += 1
        handleRoutingFromToForReceivedArguments = (currentNode: currentNode,
                                                   destinationDescendent: destinationDescendent,
                                                   router: router)
        handleRoutingFromToForClosure?(currentNode, destinationDescendent, router)
    }

}
