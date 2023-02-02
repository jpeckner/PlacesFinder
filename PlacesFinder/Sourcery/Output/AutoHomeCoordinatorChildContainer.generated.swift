// Generated using Sourcery 1.9.2 — https://github.com/krzysztofzablocki/Sourcery
// DO NOT EDIT
import SwiftDux
import UIKit


struct HomeCoordinatorChildContainer<TFactory: HomeCoordinatorChildFactoryProtocol> {
    private let search: TabCoordinatorProtocol
    private let settings: TabCoordinatorProtocol

    init<TStore>(childFactory: TFactory) where TStore.TState == AppState, TFactory.TStore == TStore {
        self.search = childFactory.buildCoordinator(for: .search)
        self.settings = childFactory.buildCoordinator(for: .settings)
    }

    init(
        search: TabCoordinatorProtocol,
        settings: TabCoordinatorProtocol
    ) {
        self.search = search
        self.settings = settings
    }
}

extension HomeCoordinatorChildContainer {

    var orderedChildCoordinators: [TabCoordinatorProtocol] {
        return HomeCoordinatorImmediateDescendent.allCases.map { coordinator(for: $0) }
    }

    var orderedChildViewControllers: [UIViewController] {
        return orderedChildCoordinators.map { $0.rootViewController }
    }

    func coordinator(for childType: HomeCoordinatorImmediateDescendent) -> TabCoordinatorProtocol {
        switch childType {
        case .search:
            return search
        case .settings:
            return settings
        }
    }

}

