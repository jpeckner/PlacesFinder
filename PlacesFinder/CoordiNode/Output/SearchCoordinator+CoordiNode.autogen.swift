// Generated using CoordiNode 1.1.0 — https://github.com/jpeckner/CoordiNode
// DO NOT EDIT

import CoordiNode

enum SearchCoordinatorNode: DestinationNodeProtocol {}

extension SearchCoordinator: DestinationCoordinatorProtocol {}

extension SearchCoordinator {
    static var destinationNodeBox: DestinationNodeBox {
        return SearchCoordinatorNode.destinationNodeBox
    }
}
