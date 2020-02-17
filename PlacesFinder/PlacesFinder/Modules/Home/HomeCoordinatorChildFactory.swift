//
//  HomeCoordinatorChildFactory.swift
//  PlacesFinder
//
//  Created by Justin Peckner.
//  Copyright © 2019 Justin Peckner. All rights reserved.
//

import CoordiNode
import Shared
import SwiftDux

class HomeCoordinatorChildFactory<TStore: StoreProtocol> where TStore.State == AppState {

    let store: TStore
    private let listenerContainer: ListenerContainer
    private let serviceContainer: ServiceContainer

    init(store: TStore,
         listenerContainer: ListenerContainer,
         serviceContainer: ServiceContainer) {
        self.store = store
        self.listenerContainer = listenerContainer
        self.serviceContainer = serviceContainer
    }

    func buildCoordinator(for destinationDescendent: HomeCoordinatorDestinationDescendent) -> TabCoordinatorProtocol {
        let immediateDescendent =
            HomeCoordinatorDescendent(destinationDescendent: destinationDescendent).immediateDescendent

        switch immediateDescendent {
        case .search:
            return buildSearchCoordinator(immediateDescendent.tabItemProperties)
        case .settings:
            return buildSettingsCoordinator(immediateDescendent.tabItemProperties)
        }
    }

    private func buildSearchCoordinator(_ tabItemProperties: TabItemProperties) -> TabCoordinatorProtocol {
        let searchEntityModelBuilder = SearchEntityModelBuilder()
        let actionCreatorDependencies = SearchActionCreatorDependencies(
            placeLookupService: serviceContainer.placeLookupService,
            searchEntityModelBuilder: searchEntityModelBuilder
        )
        let actionPrism = SearchActionPrism(dependencies: actionCreatorDependencies,
                                            actionCreator: SearchActionCreator.self)
        let copyFormatter = SearchCopyFormatter()

        let presenter: SearchPresenterProtocol
        if #available(iOS 13.0, *) {
            presenter = SearchPresenterSUI(store: store,
                                           actionPrism: actionPrism,
                                           tabItemProperties: tabItemProperties)
        } else {
            presenter = SearchPresenter(store: store,
                                        actionPrism: actionPrism,
                                        tabItemProperties: tabItemProperties)
        }

        let statePrism = SearchStatePrism(locationAuthListener: listenerContainer.locationAuthListener,
                                          locationRequestHandler: serviceContainer.locationRequestHandler)

        return SearchCoordinator(store: store,
                                 presenter: presenter,
                                 urlOpenerService: serviceContainer.urlOpenerService,
                                 copyFormatter: copyFormatter,
                                 statePrism: statePrism,
                                 actionPrism: actionPrism)
    }

    private func buildSettingsCoordinator(_ tabItemProperties: TabItemProperties) -> TabCoordinatorProtocol {
        let presenter: SettingsPresenterProtocol
        if #available(iOS 13.0, *) {
            presenter = SettingsPresenterSUI(tabItemProperties: tabItemProperties,
                                             store: store)
        } else {
            presenter = SettingsPresenter(tabItemProperties: tabItemProperties,
                                          store: store)
        }

        let measurementFormatter = MeasurementFormatter()
        measurementFormatter.unitOptions = .providedUnit

        return SettingsCoordinator(store: store,
                                   presenter: presenter,
                                   measurementFormatter: measurementFormatter)
    }

}

private extension HomeCoordinatorImmediateDescendent {

    var tabItemProperties: TabItemProperties {
        switch self {
        case .search:
            return TabItemProperties(image: #imageLiteral(resourceName: "magnifying_glass"))
        case .settings:
            return TabItemProperties(image: #imageLiteral(resourceName: "gear"))
        }
    }

}
