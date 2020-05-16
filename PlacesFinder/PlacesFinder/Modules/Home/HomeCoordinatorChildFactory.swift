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

// sourcery: genericTypes = "TStore: StoreProtocol"
// sourcery: genericConstraints = "TStore.State == AppState"
protocol HomeCoordinatorChildFactoryProtocol: AutoMockable {
    associatedtype TStore: StoreProtocol where TStore.State == AppState

    func buildCoordinator(for destinationDescendent: HomeCoordinatorDestinationDescendent) -> TabCoordinatorProtocol
}

// swiftlint:disable line_length
class HomeCoordinatorChildFactory<TStore: StoreProtocol>: HomeCoordinatorChildFactoryProtocol where TStore.State == AppState {
// swiftlint:enable line_length

    private let store: TStore
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
        let presenter = SearchPresenterSUI(tabItemProperties: tabItemProperties)
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
            copyFormatter: serviceContainer.searchCopyFormatter,
            contentViewModelBuilder: contentViewModelBuilder,
            instructionsViewModelBuilder: instructionsViewModelBuilder
        )

        let detailsViewModelBuilder = SearchDetailsViewModelBuilder(store: store,
                                                                    actionPrism: actionPrism,
                                                                    urlOpenerService: serviceContainer.urlOpenerService,
                                                                    copyFormatter: serviceContainer.searchCopyFormatter)
        let detailsViewContextBuilder = SearchDetailsViewContextBuilder(
            detailsViewModelBuilder: detailsViewModelBuilder
        )

        let navigationBarViewModelBuilder = NavigationBarViewModelBuilder()

        return SearchCoordinator(store: store,
                                 presenter: presenter,
                                 urlOpenerService: serviceContainer.urlOpenerService,
                                 statePrism: statePrism,
                                 actionPrism: actionPrism,
                                 backgroundViewModelBuilder: backgroundViewModelBuilder,
                                 lookupViewModelBuilder: lookupViewModelBuilder,
                                 detailsViewContextBuilder: detailsViewContextBuilder,
                                 navigationBarViewModelBuilder: navigationBarViewModelBuilder)
    }

    private func buildSettingsCoordinator(_ tabItemProperties: TabItemProperties) -> TabCoordinatorProtocol {
        let presenter = SettingsPresenterSUI(tabItemProperties: tabItemProperties)

        let measurementFormatter = MeasurementFormatter()
        measurementFormatter.unitOptions = .providedUnit

        let measurementSystemHeaderViewModelBuilder = SettingsUnitsHeaderViewModelBuilder(store: store)
        let plainHeaderViewModelBuilder = SettingsPlainHeaderViewModelBuilder()
        let settingsCellViewModelBuilder = SettingsCellViewModelBuilder(store: store,
                                                                        measurementFormatter: measurementFormatter)
        let settingsViewModelBuilder = SettingsViewModelBuilder(
            store: store,
            measurementSystemHeaderViewModelBuilder: measurementSystemHeaderViewModelBuilder,
            plainHeaderViewModelBuilder: plainHeaderViewModelBuilder,
            settingsCellViewModelBuilder: settingsCellViewModelBuilder
        )

        let navigationBarViewModelBuilder = NavigationBarViewModelBuilder()

        return SettingsCoordinator(store: store,
                                   presenter: presenter,
                                   settingsViewModelBuilder: settingsViewModelBuilder,
                                   navigationBarViewModelBuilder: navigationBarViewModelBuilder)
    }

}

private extension HomeCoordinatorImmediateDescendent {

    var tabItemProperties: TabItemProperties {
        switch self {
        case .search:
            return TabItemProperties(imageName: "magnifying_glass")
        case .settings:
            return TabItemProperties(imageName: "gear")
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

        let childBuilder = SearchLookupChildBuilder(store: store,
                                                    actionPrism: actionPrism,
                                                    instructionsViewModelBuilder: instructionsViewModelBuilder,
                                                    resultsViewModelBuilder: resultsViewModelBuilder,
                                                    noResultsFoundViewModelBuilder: noResultsFoundViewModelBuilder,
                                                    retryViewModelBuilder: retryViewModelBuilder)

        self.init(store: store,
                  actionPrism: actionPrism,
                  inputViewModelBuilder: inputViewModelBuilder,
                  childBuilder: childBuilder)
    }

}
