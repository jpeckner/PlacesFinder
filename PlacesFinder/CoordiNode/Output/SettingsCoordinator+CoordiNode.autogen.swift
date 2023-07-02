// Generated using CoordiNode 1.1.1 — https://github.com/jpeckner/CoordiNode
// DO NOT EDIT

import CoordiNode

enum SettingsCoordinatorNode: DestinationNodeProtocol {}

extension SettingsCoordinator: DestinationRouterProtocol {}

extension SettingsCoordinator {
    nonisolated static var destinationNodeBox: DestinationNodeBox {
        return SettingsCoordinatorNode.destinationNodeBox
    }
}


extension SettingsCoordinator {
    typealias TDescendent = SettingsCoordinatorDescendent
}

// MARK: SettingsCoordinatorDescendent

enum SettingsCoordinatorDescendent: CaseIterable {
    case aboutApp
}

extension SettingsCoordinatorDescendent: DescendentProtocol {

    init?(nodeBox: NodeBox) {
        guard let matchingCase = (SettingsCoordinatorDescendent.allCases.first {
            $0.nodeBox == nodeBox
        }) else {
            return nil
        }

        self = matchingCase
    }

    init(destinationDescendent: SettingsCoordinatorDestinationDescendent) {
        switch destinationDescendent {
        case .aboutApp:
            self = .aboutApp
        }
    }

    var nodeBox: NodeBox {
        switch self {
        case .aboutApp:
            return AboutAppCoordinatorNode.nodeBox
        }
    }

    var immediateDescendent: SettingsCoordinatorImmediateDescendent {
        switch self {
        case .aboutApp:
            return .aboutApp
        }
    }

}

// MARK: SettingsCoordinatorImmediateDescendent

enum SettingsCoordinatorImmediateDescendent: CaseIterable {
    case aboutApp
}

extension SettingsCoordinatorImmediateDescendent: ImmediateDescendentProtocol {

    init?(nodeBox: NodeBox) {
        guard let matchingCase = (SettingsCoordinatorImmediateDescendent.allCases.first {
            $0.nodeBox == nodeBox
        }) else {
            return nil
        }

        self = matchingCase
    }

    var nodeBox: NodeBox {
        switch self {
        case .aboutApp:
            return AboutAppCoordinatorNode.nodeBox
        }
    }

}

// MARK: SettingsCoordinatorDestinationDescendent

enum SettingsCoordinatorDestinationDescendent: CaseIterable {
    case aboutApp
}

extension SettingsCoordinatorDestinationDescendent: DestinationDescendentProtocol {

    init?(destinationNodeBox: DestinationNodeBox) {
        guard let matchingCase = (SettingsCoordinatorDestinationDescendent.allCases.first {
            $0.destinationNodeBox == destinationNodeBox
        }) else {
            return nil
        }

        self = matchingCase
    }

    var destinationNodeBox: DestinationNodeBox {
        switch self {
        case .aboutApp:
            return AboutAppCoordinatorNode.destinationNodeBox
        }
    }

}
