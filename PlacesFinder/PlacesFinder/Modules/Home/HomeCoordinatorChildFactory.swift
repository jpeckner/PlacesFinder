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
        let presenter = SearchPresenter(tabItemProperties: tabItemProperties)

        let copyFormatter = SearchCopyFormatter()

        let statePrism = SearchStatePrism(locationAuthListener: listenerContainer.locationAuthListener,
                                          locationRequestHandler: serviceContainer.locationRequestHandler)

        let searchEntityModelBuilder = SearchEntityModelBuilder()
        let actionCreatorDependencies = SearchActionCreatorDependencies(
            placeLookupService: serviceContainer.placeLookupService,
            searchEntityModelBuilder: searchEntityModelBuilder
        )
        let actionPrism = SearchActionPrism(dependencies: actionCreatorDependencies,
                                            actionCreator: SearchActionCreator.self)

        return SearchCoordinator(store: store,
                                 presenter: presenter,
                                 urlOpenerService: serviceContainer.urlOpenerService,
                                 copyFormatter: copyFormatter,
                                 statePrism: statePrism,
                                 actionPrism: actionPrism)
    }

    private func buildSettingsCoordinator(_ tabItemProperties: TabItemProperties) -> TabCoordinatorProtocol {
        let presenter = SettingsPresenter(tabItemProperties: tabItemProperties)

        let measurementFormatter = MeasurementFormatter()
        measurementFormatter.unitOptions = .providedUnit

        let measurementSystemHeaderViewModelBuilder = SettingsUnitsHeaderViewModelBuilder(store: store)
        let plainHeaderViewModelBuilder = SettingsPlainHeaderViewModelBuilder()
        let settingsCellViewModelBuilder = SettingsCellViewModelBuilder(store: store,
                                                                        measurementFormatter: measurementFormatter)
        let viewModelBuilder = SettingsViewModelBuilder(
            store: store,
            measurementSystemHeaderViewModelBuilder: measurementSystemHeaderViewModelBuilder,
            plainHeaderViewModelBuilder: plainHeaderViewModelBuilder,
            settingsCellViewModelBuilder: settingsCellViewModelBuilder
        )

        return SettingsCoordinator(store: store,
                                   presenter: presenter,
                                   viewModelBuilder: viewModelBuilder)
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
