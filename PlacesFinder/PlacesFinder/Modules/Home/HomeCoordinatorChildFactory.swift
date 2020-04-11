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
        let presenter: SearchPresenterProtocol
        if #available(iOS 13.0, *) {
            presenter = SearchPresenterSUI(tabItemProperties: tabItemProperties)
        } else {
            presenter = SearchPresenter(tabItemProperties: tabItemProperties)
        }

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

        let contentViewModelBuilder = SearchInputContentViewModelBuilder()
        let instructionsViewModelBuilder = SearchInstructionsViewModelBuilder()
        let backgroundViewModelBuilder = SearchBackgroundViewModelBuilder(
            contentViewModelBuilder: contentViewModelBuilder,
            instructionsViewModelBuilder: instructionsViewModelBuilder
        )
        let lookupViewModelBuilder = SearchLookupViewModelBuilder(
            store: store,
            actionPrism: actionPrism,
            copyFormatter: copyFormatter,
            contentViewModelBuilder: contentViewModelBuilder,
            instructionsViewModelBuilder: instructionsViewModelBuilder
        )

        return SearchCoordinator(store: store,
                                 presenter: presenter,
                                 urlOpenerService: serviceContainer.urlOpenerService,
                                 copyFormatter: copyFormatter,
                                 statePrism: statePrism,
                                 actionPrism: actionPrism,
                                 backgroundViewModelBuilder: backgroundViewModelBuilder,
                                 lookupViewModelBuilder: lookupViewModelBuilder)
    }

    private func buildSettingsCoordinator(_ tabItemProperties: TabItemProperties) -> TabCoordinatorProtocol {
        let presenter: SettingsPresenterProtocol
        if #available(iOS 13.0, *) {
            presenter = SettingsPresenterSUI(tabItemProperties: tabItemProperties)
        } else {
            presenter = SettingsPresenter(tabItemProperties: tabItemProperties)
        }

        let measurementFormatter = MeasurementFormatter()
        measurementFormatter.unitOptions = .providedUnit

        let measurementSystemHeaderViewModelBuilder = SettingsUnitsHeaderViewModelBuilder()
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

private extension SearchLookupViewModelBuilder {

    convenience init(store: DispatchingStoreProtocol,
                     actionPrism: SearchActionPrismProtocol,
                     copyFormatter: SearchCopyFormatterProtocol,
                     contentViewModelBuilder: SearchInputContentViewModelBuilderProtocol,
                     instructionsViewModelBuilder: SearchInstructionsViewModelBuilderProtocol) {
        let inputViewModelBuilder = SearchInputViewModelBuilder(store: store,
                                                                actionPrism: actionPrism,
                                                                contentViewModelBuilder: contentViewModelBuilder)

        let resultCellModelBuilder = SearchResultCellModelBuilder(copyFormatter: copyFormatter)
        let resultViewModelBuilder = SearchResultViewModelBuilder(store: store,
                                                                  actionPrism: actionPrism,
                                                                  copyFormatter: copyFormatter,
                                                                  resultCellModelBuilder: resultCellModelBuilder)
        let resultsViewModelBuilder = SearchResultsViewModelBuilder(store: store,
                                                                    actionPrism: actionPrism,
                                                                    resultViewModelBuilder: resultViewModelBuilder)
        let noResultsFoundViewModelBuilder = SearchNoResultsFoundViewModelBuilder()
        let retryViewModelBuilder = SearchRetryViewModelBuilder()

        let childBuilder = SearchLookupChildBuilder(instructionsViewModelBuilder: instructionsViewModelBuilder,
                                                    resultsViewModelBuilder: resultsViewModelBuilder,
                                                    noResultsFoundViewModelBuilder: noResultsFoundViewModelBuilder,
                                                    retryViewModelBuilder: retryViewModelBuilder)

        self.init(inputViewModelBuilder: inputViewModelBuilder,
                  childBuilder: childBuilder)
    }

}
