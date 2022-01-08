// Generated using CoordiNode 1.0.4 — https://github.com/jpeckner/CoordiNode
// DO NOT EDIT

import CoordiNode

enum LaunchCoordinatorNode: NodeProtocol {}

extension LaunchCoordinator: CoordinatorProtocol {}

extension LaunchCoordinator {
    static var nodeBox: NodeBox {
        return LaunchCoordinatorNode.nodeBox
    }
}
