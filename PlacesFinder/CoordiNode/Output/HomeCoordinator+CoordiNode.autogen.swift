// Generated using CoordiNode 1.1.1 — https://github.com/jpeckner/CoordiNode
// DO NOT EDIT

import CoordiNode

enum HomeCoordinatorNode: NodeProtocol {}

extension HomeCoordinator: RouterProtocol {}

extension HomeCoordinator {
    nonisolated static var nodeBox: NodeBox {
        return HomeCoordinatorNode.nodeBox
    }
}


extension HomeCoordinator {
    typealias TDescendent = HomeCoordinatorDescendent
}

// MARK: HomeCoordinatorDescendent

enum HomeCoordinatorDescendent: CaseIterable {
    case search
    case settings
    case settingsChild
}

extension HomeCoordinatorDescendent: DescendentProtocol {

    init?(nodeBox: NodeBox) {
        guard let matchingCase = (HomeCoordinatorDescendent.allCases.first {
            $0.nodeBox == nodeBox
        }) else {
            return nil
        }

        self = matchingCase
    }

    init(destinationDescendent: HomeCoordinatorDestinationDescendent) {
        switch destinationDescendent {
        case .search:
            self = .search
        case .settings:
            self = .settings
        case .settingsChild:
            self = .settingsChild
        }
    }

    var nodeBox: NodeBox {
        switch self {
        case .search:
            return SearchCoordinatorNode.nodeBox
        case .settings:
            return SettingsCoordinatorNode.nodeBox
        case .settingsChild:
            return SettingsChildCoordinatorNode.nodeBox
        }
    }

    var immediateDescendent: HomeCoordinatorImmediateDescendent {
        switch self {
        case .search:
            return .search
        case .settings:
            return .settings
        case .settingsChild:
            return .settings
        }
    }

}

// MARK: HomeCoordinatorImmediateDescendent

enum HomeCoordinatorImmediateDescendent: CaseIterable {
    case search
    case settings
}

extension HomeCoordinatorImmediateDescendent: ImmediateDescendentProtocol {

    init?(nodeBox: NodeBox) {
        guard let matchingCase = (HomeCoordinatorImmediateDescendent.allCases.first {
            $0.nodeBox == nodeBox
        }) else {
            return nil
        }

        self = matchingCase
    }

    var nodeBox: NodeBox {
        switch self {
        case .search:
            return SearchCoordinatorNode.nodeBox
        case .settings:
            return SettingsCoordinatorNode.nodeBox
        }
    }

}

// MARK: HomeCoordinatorDestinationDescendent

enum HomeCoordinatorDestinationDescendent: CaseIterable {
    case search
    case settings
    case settingsChild
}

extension HomeCoordinatorDestinationDescendent: DestinationDescendentProtocol {

    init?(destinationNodeBox: DestinationNodeBox) {
        guard let matchingCase = (HomeCoordinatorDestinationDescendent.allCases.first {
            $0.destinationNodeBox == destinationNodeBox
        }) else {
            return nil
        }

        self = matchingCase
    }

    var destinationNodeBox: DestinationNodeBox {
        switch self {
        case .search:
            return SearchCoordinatorNode.destinationNodeBox
        case .settings:
            return SettingsCoordinatorNode.destinationNodeBox
        case .settingsChild:
            return SettingsChildCoordinatorNode.destinationNodeBox
        }
    }

}
