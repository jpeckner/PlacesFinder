// Generated using CoordiNode 1.1.1 — https://github.com/jpeckner/CoordiNode
// DO NOT EDIT

import CoordiNode

enum AppCoordinatorNode: NodeProtocol {}

extension AppCoordinator: RouterProtocol, RootCoordinatorProtocol {}

extension AppCoordinator {
    nonisolated static var nodeBox: NodeBox {
        return AppCoordinatorNode.nodeBox
    }
}


extension AppCoordinator {
    typealias TDescendent = AppCoordinatorDescendent
}

// MARK: AppCoordinatorDescendent

enum AppCoordinatorDescendent: CaseIterable {
    case launch
    case home
    case search
    case settings
    case settingsChild
}

extension AppCoordinatorDescendent: DescendentProtocol {

    init?(nodeBox: NodeBox) {
        guard let matchingCase = (AppCoordinatorDescendent.allCases.first {
            $0.nodeBox == nodeBox
        }) else {
            return nil
        }

        self = matchingCase
    }

    init(destinationDescendent: AppCoordinatorDestinationDescendent) {
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
        case .launch:
            return LaunchCoordinatorNode.nodeBox
        case .home:
            return HomeCoordinatorNode.nodeBox
        case .search:
            return SearchCoordinatorNode.nodeBox
        case .settings:
            return SettingsCoordinatorNode.nodeBox
        case .settingsChild:
            return SettingsChildCoordinatorNode.nodeBox
        }
    }

    var immediateDescendent: AppCoordinatorImmediateDescendent {
        switch self {
        case .launch:
            return .launch
        case .home:
            return .home
        case .search:
            return .home
        case .settings:
            return .home
        case .settingsChild:
            return .home
        }
    }

}

// MARK: AppCoordinatorImmediateDescendent

enum AppCoordinatorImmediateDescendent: CaseIterable {
    case launch
    case home
}

extension AppCoordinatorImmediateDescendent: ImmediateDescendentProtocol {

    init?(nodeBox: NodeBox) {
        guard let matchingCase = (AppCoordinatorImmediateDescendent.allCases.first {
            $0.nodeBox == nodeBox
        }) else {
            return nil
        }

        self = matchingCase
    }

    var nodeBox: NodeBox {
        switch self {
        case .launch:
            return LaunchCoordinatorNode.nodeBox
        case .home:
            return HomeCoordinatorNode.nodeBox
        }
    }

}

// MARK: AppCoordinatorDestinationDescendent

enum AppCoordinatorDestinationDescendent: CaseIterable {
    case search
    case settings
    case settingsChild
}

extension AppCoordinatorDestinationDescendent: DestinationDescendentProtocol {

    init?(destinationNodeBox: DestinationNodeBox) {
        guard let matchingCase = (AppCoordinatorDestinationDescendent.allCases.first {
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
