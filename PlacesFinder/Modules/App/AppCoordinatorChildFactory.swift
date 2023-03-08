//
//  AppCoordinatorChildFactory.swift
//  PlacesFinder
//
//  Copyright (c) 2018 Justin Peckner
//  
//  Permission is hereby granted, free of charge, to any person obtaining a copy
//  of this software and associated documentation files (the "Software"), to deal
//  in the Software without restriction, including without limitation the rights
//  to use, copy, modify, merge, publish, distribute, sublicense, and/or sell
//  copies of the Software, and to permit persons to whom the Software is
//  furnished to do so, subject to the following conditions:
//  
//  The above copyright notice and this permission notice shall be included in all
//  copies or substantial portions of the Software.
//  
//  THE SOFTWARE IS PROVIDED "AS IS", WITHOUT WARRANTY OF ANY KIND, EXPRESS OR
//  IMPLIED, INCLUDING BUT NOT LIMITED TO THE WARRANTIES OF MERCHANTABILITY,
//  FITNESS FOR A PARTICULAR PURPOSE AND NONINFRINGEMENT. IN NO EVENT SHALL THE
//  AUTHORS OR COPYRIGHT HOLDERS BE LIABLE FOR ANY CLAIM, DAMAGES OR OTHER
//  LIABILITY, WHETHER IN AN ACTION OF CONTRACT, TORT OR OTHERWISE, ARISING FROM,
//  OUT OF OR IN CONNECTION WITH THE SOFTWARE OR THE USE OR OTHER DEALINGS IN THE
//  SOFTWARE.

import Foundation
import Shared
import SwiftDux

protocol AppCoordinatorChildProtocol: ChildCoordinatorProtocol {
    nonisolated static var appCoordinatorImmediateDescendent: AppCoordinatorImmediateDescendent { get }
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

// sourcery: AutoMockable
// sourcery: genericTypes = "TStore: StoreProtocol"
// sourcery: genericConstraints = "TStore.TState == AppState, TStore.TAction == AppAction"
protocol AppCoordinatorChildFactoryProtocol {
    associatedtype TStore: StoreProtocol where TStore.TAction == AppAction, TStore.TState == AppState

    var store: TStore { get }
    var serviceContainer: ServiceContainer { get }
    var launchStatePrism: LaunchStatePrismProtocol { get }

    @MainActor
    func buildLaunchCoordinator() -> AppCoordinatorChildProtocol

    @MainActor
    func buildCoordinator(for childType: AppCoordinatorDestinationDescendent) -> AppCoordinatorChildProtocol
}

class AppCoordinatorChildFactory<TStore: StoreProtocol> where TStore.TAction == AppAction, TStore.TState == AppState {

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
        let appSkin = AppSkin(colorings: AppColorings.defaultColorings)
        let presenter = LaunchPresenter(appSkin: appSkin)
        let stylingsHandler = AppGlobalStylingsHandler()

        return LaunchCoordinator(store: store,
                                 presenter: presenter,
                                 listenerContainer: listenerContainer,
                                 statePrism: launchStatePrism,
                                 stylingsHandler: stylingsHandler,
                                 defaultLinkType: defaultLinkType)
    }

    func buildCoordinator(for childType: AppCoordinatorDestinationDescendent) -> AppCoordinatorChildProtocol {
        switch childType {
        case .search,
             .settings,
             .settingsChild:
            let childFactory = HomeCoordinatorChildFactory(store: store,
                                                           listenerContainer: listenerContainer,
                                                           serviceContainer: serviceContainer)
            let childContainer = HomeCoordinatorChildContainer(childFactory: childFactory)
            let presenter = HomePresenter(orderedChildViewControllers: childContainer.orderedChildViewControllers)

            return HomeCoordinator(store: store,
                                   childContainer: childContainer,
                                   presenter: presenter,
                                   appRoutingHandler: serviceContainer.appRoutingHandler)
        }
    }

}
