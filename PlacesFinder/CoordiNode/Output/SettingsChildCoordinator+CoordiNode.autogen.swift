// Generated using CoordiNode 1.1.0 — https://github.com/jpeckner/CoordiNode
// DO NOT EDIT

import CoordiNode

enum SettingsChildCoordinatorNode: DestinationNodeProtocol {}

extension SettingsChildCoordinator: DestinationCoordinatorProtocol {}

extension SettingsChildCoordinator {
    static var destinationNodeBox: DestinationNodeBox {
        return SettingsChildCoordinatorNode.destinationNodeBox
    }
}
