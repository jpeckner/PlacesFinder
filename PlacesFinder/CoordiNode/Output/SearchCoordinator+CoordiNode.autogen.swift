// Generated using CoordiNode 1.1.1 — https://github.com/jpeckner/CoordiNode
// DO NOT EDIT

import CoordiNode

enum SearchCoordinatorNode: DestinationNodeProtocol {}

extension SearchCoordinator: DestinationCoordinatorProtocol {}

extension SearchCoordinator {
    nonisolated static var destinationNodeBox: DestinationNodeBox {
        return SearchCoordinatorNode.destinationNodeBox
    }
}
