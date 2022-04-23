//
//  HomeCoordinatorChildFactory.swift
//  PlacesFinder
//
//  Copyright (c) 2019 Justin Peckner
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

import Combine
import CoordiNode
import Shared
import SwiftDux

// sourcery: genericTypes = "TStore: StoreProtocol"
// sourcery: genericConstraints = "TStore.State == AppState"
protocol HomeCoordinatorChildFactoryProtocol: AutoMockable {
    associatedtype TStore: StoreProtocol where TStore.TAction == AppAction, TStore.TState == AppState

    func buildCoordinator(for destinationDescendent: HomeCoordinatorDestinationDescendent) -> TabCoordinatorProtocol
}

class HomeCoordinatorChildFactory<TStore: StoreProtocol> where TStore.TAction == AppAction, TStore.TState == AppState {
    private let store: TStore
    private let listenerContainer: ListenerContainer
    private let serviceContainer: ServiceContainer
    private let actionSubscriber: AnySubscriber<AppAction, Never>

    init(store: TStore,
         listenerContainer: ListenerContainer,
         serviceContainer: ServiceContainer) {
        self.store = store
        self.listenerContainer = listenerContainer
        self.serviceContainer = serviceContainer
        self.actionSubscriber = AnySubscriber(ActionSubscriber(store: store))
    }
}

extension HomeCoordinatorChildFactory: HomeCoordinatorChildFactoryProtocol {

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
        let initialState = Search.State()
        let searchStore = Search.SearchStore(
            reducer: Search.reduce,
            initialState: initialState,
            middleware: [
                Search.makeStateReceiverMiddleware(),
                Search.ActivityMiddleware.makeInitialRequestMiddleware(appStore: store),
                Search.ActivityMiddleware.makeSubsequentRequestMiddleware()
            ]
        )

        let searchActionSubscriber = AnySubscriber(ActionSubscriber(store: searchStore))

        let presenter = SearchPresenter(tabItemProperties: tabItemProperties)

        let statePrism = SearchActivityStatePrism(locationAuthListener: listenerContainer.locationAuthListener,
                                                  locationRequestHandler: serviceContainer.locationRequestHandler)

        let searchEntityModelBuilder = SearchEntityModelBuilder()
        let actionCreatorDependencies = Search.ActivityActionCreatorDependencies(
            placeLookupService: serviceContainer.placeLookupService,
            searchEntityModelBuilder: searchEntityModelBuilder
        )
        let actionPrism = SearchActivityActionPrism(dependencies: actionCreatorDependencies)

        let contentViewModelBuilder = SearchInputContentViewModelBuilder()
        let instructionsViewModelBuilder = SearchInstructionsViewModelBuilder()
        let backgroundViewModelBuilder = SearchBackgroundViewModelBuilder(
            contentViewModelBuilder: contentViewModelBuilder,
            instructionsViewModelBuilder: instructionsViewModelBuilder
        )
        let lookupViewModelBuilder = SearchLookupViewModelBuilder(
            actionSubscriber: searchActionSubscriber,
            actionPrism: actionPrism,
            copyFormatter: serviceContainer.searchCopyFormatter,
            contentViewModelBuilder: contentViewModelBuilder,
            instructionsViewModelBuilder: instructionsViewModelBuilder
        )

        let detailsViewModelBuilder = SearchDetailsViewModelBuilder(actionSubscriber: searchActionSubscriber,
                                                                    actionPrism: actionPrism,
                                                                    urlOpenerService: serviceContainer.urlOpenerService,
                                                                    copyFormatter: serviceContainer.searchCopyFormatter)
        let detailsViewContextBuilder = SearchDetailsViewContextBuilder(
            detailsViewModelBuilder: detailsViewModelBuilder
        )

        let navigationBarViewModelBuilder = NavigationBarViewModelBuilder()

        return SearchCoordinator(appStore: store,
                                 searchStore: searchStore,
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
        let presenter = SettingsPresenter(tabItemProperties: tabItemProperties)

        let measurementFormatter = MeasurementFormatter()
        measurementFormatter.unitOptions = .providedUnit

        let unitsHeaderViewModelBuilder = SettingsUnitsHeaderViewModelBuilder(actionSubscriber: actionSubscriber)
        let plainHeaderViewModelBuilder = SettingsPlainHeaderViewModelBuilder()
        let settingsCellViewModelBuilder = SettingsCellViewModelBuilder(actionSubscriber: actionSubscriber,
                                                                        measurementFormatter: measurementFormatter)
        let settingsViewModelBuilder = SettingsViewModelBuilder(
            actionSubscriber: actionSubscriber,
            measurementSystemHeaderViewModelBuilder: unitsHeaderViewModelBuilder,
            plainHeaderViewModelBuilder: plainHeaderViewModelBuilder,
            settingsCellViewModelBuilder: settingsCellViewModelBuilder
        )

        let navigationBarViewModelBuilder = NavigationBarViewModelBuilder()

        return SettingsCoordinator(store: store,
                                   presenter: presenter,
                                   serviceContainer: serviceContainer,
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

    convenience init(actionSubscriber: AnySubscriber<Search.Action, Never>,
                     actionPrism: SearchActivityActionPrismProtocol,
                     copyFormatter: SearchCopyFormatterProtocol,
                     contentViewModelBuilder: SearchInputContentViewModelBuilderProtocol,
                     instructionsViewModelBuilder: SearchInstructionsViewModelBuilderProtocol) {
        let inputViewModelBuilder = SearchInputViewModelBuilder(actionSubscriber: actionSubscriber,
                                                                actionPrism: actionPrism,
                                                                contentViewModelBuilder: contentViewModelBuilder)

        let resultCellModelBuilder = SearchResultCellModelBuilder(copyFormatter: copyFormatter)
        let resultViewModelBuilder = SearchResultViewModelBuilder(actionSubscriber: actionSubscriber,
                                                                  actionPrism: actionPrism,
                                                                  resultCellModelBuilder: resultCellModelBuilder)
        let resultsViewModelBuilder = SearchResultsViewModelBuilder(actionPrism: actionPrism,
                                                                    resultViewModelBuilder: resultViewModelBuilder)
        let noResultsFoundViewModelBuilder = SearchNoResultsFoundViewModelBuilder()
        let retryViewModelBuilder = SearchRetryViewModelBuilder()

        let childBuilder = SearchLookupChildBuilder(actionSubscriber: actionSubscriber,
                                                    actionPrism: actionPrism,
                                                    instructionsViewModelBuilder: instructionsViewModelBuilder,
                                                    resultsViewModelBuilder: resultsViewModelBuilder,
                                                    noResultsFoundViewModelBuilder: noResultsFoundViewModelBuilder,
                                                    retryViewModelBuilder: retryViewModelBuilder)

        self.init(inputViewModelBuilder: inputViewModelBuilder,
                  childBuilder: childBuilder)
    }

}
