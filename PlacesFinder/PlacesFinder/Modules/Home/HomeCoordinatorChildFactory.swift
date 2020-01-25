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
            let searchEntityModelBuilder = SearchEntityModelBuilder()
            let actionCreatorDependencies = SearchActionCreatorDependencies(
                placeLookupService: serviceContainer.placeLookupService,
                searchEntityModelBuilder: searchEntityModelBuilder
            )
            let actionPrism = SearchActionPrism(dependencies: actionCreatorDependencies,
                                                actionCreator: SearchActionCreator.self)
            let copyFormatter = SearchCopyFormatter()

            let presenter = SearchPresenter(store: store,
                                            actionPrism: actionPrism,
                                            tabItemProperties: immediateDescendent.tabItemProperties)

            let statePrism = SearchStatePrism(locationAuthListener: listenerContainer.locationAuthListener,
                                              locationRequestHandler: serviceContainer.locationRequestHandler)

            return SearchCoordinator(store: store,
                                     presenter: presenter,
                                     urlOpenerService: serviceContainer.urlOpenerService,
                                     copyFormatter: copyFormatter,
                                     statePrism: statePrism,
                                     actionPrism: actionPrism)
        case .settings:
            let presenter: SettingsPresenterProtocol
            if #available(iOS 13.0, *) {
                presenter = SettingsPresenterSUI(tabItemProperties: immediateDescendent.tabItemProperties,
                                                 store: store)
            } else {
                presenter = SettingsPresenter(tabItemProperties: immediateDescendent.tabItemProperties,
                                              store: store)
            }

            let measurementFormatter = MeasurementFormatter()
            measurementFormatter.unitOptions = .providedUnit

            return SettingsCoordinator(store: store,
                                       presenter: presenter,
                                       measurementFormatter: measurementFormatter)
        }
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
