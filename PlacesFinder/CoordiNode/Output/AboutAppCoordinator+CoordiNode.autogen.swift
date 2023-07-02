// Generated using CoordiNode 1.1.1 — https://github.com/jpeckner/CoordiNode
// DO NOT EDIT

import CoordiNode

enum AboutAppCoordinatorNode: DestinationNodeProtocol {}

extension AboutAppCoordinator: DestinationCoordinatorProtocol {}

extension AboutAppCoordinator {
    nonisolated static var destinationNodeBox: DestinationNodeBox {
        return AboutAppCoordinatorNode.destinationNodeBox
    }
}
