//
//  AppCoordinatorChildFactory.swift
//  PlacesFinder
//
//  Created by Justin Peckner.
//  Copyright © 2018 Justin Peckner. All rights reserved.
//

import Foundation
import Shared
import SwiftDux

protocol AppCoordinatorChildProtocol: ChildCoordinatorProtocol {
    static var appCoordinatorImmediateDescendent: AppCoordinatorImmediateDescendent { get }
}

extension HomeCoordinator: AppCoordinatorChildProtocol {

    static var appCoordinatorImmediateDescendent: AppCoordinatorImmediateDescendent {
        return .home
    }

}

extension LaunchCoordinator: AppCoordinatorChildProtocol {

    static var appCoordinatorImmediateDescendent: AppCoordinatorImmediateDescendent {
        return .launch
    }

}

// sourcery: genericTypes = "TStore: StoreProtocol"
// sourcery: genericConstraints = "TStore.State == AppState"
protocol AppCoordinatorChildFactoryProtocol: AutoMockable {
    associatedtype TStore: StoreProtocol where TStore.State == AppState

    var store: TStore { get }
    var listenerContainer: ListenerContainer { get }
    var serviceContainer: ServiceContainer { get }
    var launchStatePrism: LaunchStatePrismProtocol { get }

    func buildLaunchCoordinator() -> AppCoordinatorChildProtocol
    func buildCoordinator(for childType: AppCoordinatorDestinationDescendent) -> AppCoordinatorChildProtocol
}

class AppCoordinatorChildFactory<TStore: StoreProtocol> where TStore.State == AppState {

    let store: TStore
    let listenerContainer: ListenerContainer
    let serviceContainer: ServiceContainer
    let launchStatePrism: LaunchStatePrismProtocol
    private let defaultLinkType: AppLinkType

    init(store: TStore,
         listenerContainer: ListenerContainer,
         serviceContainer: ServiceContainer,
         launchStatePrism: LaunchStatePrismProtocol,
         defaultLinkType: AppLinkType) {
        self.store = store
        self.listenerContainer = listenerContainer
        self.serviceContainer = serviceContainer
        self.launchStatePrism = launchStatePrism
        self.defaultLinkType = defaultLinkType
    }

}

extension AppCoordinatorChildFactory: AppCoordinatorChildFactoryProtocol {

    func buildLaunchCoordinator() -> AppCoordinatorChildProtocol {
        let presenter = LaunchPresenter()
        let stylingsHandler = AppGlobalStylingsHandler()

        return LaunchCoordinator(store: store,
                                 presenter: presenter,
                                 listenerContainer: listenerContainer,
                                 serviceContainer: serviceContainer,
                                 statePrism: launchStatePrism,
                                 stylingsHandler: stylingsHandler,
                                 defaultLinkType: defaultLinkType)
    }

    func buildCoordinator(for childType: AppCoordinatorDestinationDescendent) -> AppCoordinatorChildProtocol {
        switch childType {
        case .search,
             .settings:
            let childFactory = HomeCoordinatorChildFactory(store: store,
                                                           listenerContainer: listenerContainer,
                                                           serviceContainer: serviceContainer)
            let childContainer = HomeCoordinatorChildContainer(childFactory: childFactory)
            let presenter = HomePresenter(childContainer: childContainer)

            return HomeCoordinator(store: store,
                                   childContainer: childContainer,
                                   presenter: presenter,
                                   routingHandler: serviceContainer.routingHandler)
        }
    }

}
