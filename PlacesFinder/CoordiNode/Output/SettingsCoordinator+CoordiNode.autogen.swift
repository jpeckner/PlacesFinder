// Generated using CoordiNode 1.0.4 — https://github.com/jpeckner/CoordiNode
// DO NOT EDIT

import CoordiNode

enum SettingsCoordinatorNode: DestinationNodeProtocol {}

extension SettingsCoordinator: DestinationCoordinatorProtocol {}

extension SettingsCoordinator {
    static var destinationNodeBox: DestinationNodeBox {
        return SettingsCoordinatorNode.destinationNodeBox
    }
}
