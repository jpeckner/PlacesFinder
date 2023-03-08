// Generated using CoordiNode 1.1.1 — https://github.com/jpeckner/CoordiNode
// DO NOT EDIT

import CoordiNode

enum SettingsChildCoordinatorNode: DestinationNodeProtocol {}

extension SettingsChildCoordinator: DestinationCoordinatorProtocol {}

extension SettingsChildCoordinator {
    nonisolated static var destinationNodeBox: DestinationNodeBox {
        return SettingsChildCoordinatorNode.destinationNodeBox
    }
}
