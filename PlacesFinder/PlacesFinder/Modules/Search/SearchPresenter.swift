//
//  SearchPresenter.swift
//  PlacesFinder
//
//  Created by Justin Peckner.
//  Copyright © 2018 Justin Peckner. All rights reserved.
//

import SwiftDux
import UIKit

class SearchPresenter: SearchPresenterProtocol {

    private let store: DispatchingStoreProtocol
    private let actionPrism: SearchActionPrismProtocol
    private let searchContainerViewController: SearchContainerViewController

    var rootViewController: UIViewController {
        return searchContainerViewController
    }

    init(store: DispatchingStoreProtocol,
         actionPrism: SearchActionPrismProtocol,
         tabItemProperties: TabItemProperties) {
        self.store = store
        self.actionPrism = actionPrism
        self.searchContainerViewController = SearchContainerViewController()

        searchContainerViewController.configure(tabItemProperties)
    }

    func loadNoInternetViews(_ viewModel: SearchNoInternetViewModel,
                             titleViewModel: NavigationBarTitleViewModel,
                             appSkin: AppSkin) {
        guard let existingController: SearchNoInternetViewController = existingPrimaryController() else {
            let controller = buildNoInternetViewController(viewModel,
                                                           titleViewModel: titleViewModel,
                                                           appSkin: appSkin)
            searchContainerViewController.splitControllers = SearchContainerSplitControllers(
                primaryController: controller,
                secondaryController: nil
            )
            return
        }

        existingController.configure(viewModel)
    }

    func loadLocationServicesDisabledViews(_ viewModel: SearchLocationDisabledViewModel,
                                           titleViewModel: NavigationBarTitleViewModel,
                                           appSkin: AppSkin) {
        guard let existingController: SearchLocationDisabledViewController = existingPrimaryController() else {
            let controller = buildLocationServicesDisabledViewController(viewModel,
                                                                         titleViewModel: titleViewModel,
                                                                         appSkin: appSkin)
            searchContainerViewController.splitControllers = SearchContainerSplitControllers(
                primaryController: controller,
                secondaryController: nil
            )
            return
        }

        existingController.configure(viewModel)
    }

    func loadSearchBackgroundView(_ viewModel: SearchBackgroundViewModel,
                                  titleViewModel: NavigationBarTitleViewModel,
                                  appSkin: AppSkin) {
        guard let existingController: SearchBackgroundViewController = existingPrimaryController() else {
            let controller = buildSearchBackgroundViewController(viewModel,
                                                                 titleViewModel: titleViewModel,
                                                                 appSkin: appSkin)
            searchContainerViewController.splitControllers = SearchContainerSplitControllers(
                primaryController: controller,
                secondaryController: nil
            )
            return
        }

        existingController.configure(viewModel)
    }

    func loadSearchViews(_ viewModel: SearchLookupViewModel,
                         detailsViewContext: SearchDetailsViewContext?,
                         titleViewModel: NavigationBarTitleViewModel,
                         appSkin: AppSkin,
                         searchInputBlock: @escaping SearchInputBlock) {
        let lookupController = loadOrBuildLookupController(viewModel,
                                                           titleViewModel: titleViewModel,
                                                           appSkin: appSkin,
                                                           searchInputBlock: searchInputBlock)
        let secondaryController = loadOrBuildSecondaryController(detailsViewContext,
                                                                 appSkin: appSkin)

        searchContainerViewController.splitControllers = SearchContainerSplitControllers(
            primaryController: lookupController,
            secondaryController: secondaryController
        )
    }

    private func loadOrBuildLookupController(
        _ viewModel: SearchLookupViewModel,
        titleViewModel: NavigationBarTitleViewModel,
        appSkin: AppSkin,
        searchInputBlock: @escaping SearchInputBlock
    ) -> SearchLookupParentController {
        guard let existingController: SearchLookupParentController = existingPrimaryController() else {
            return buildSearchParentViewController(viewModel,
                                                   titleViewModel: titleViewModel,
                                                   appSkin: appSkin,
                                                   searchInputBlock: searchInputBlock)
        }

        existingController.configure(viewModel,
                                     appSkin: appSkin)
        return existingController
    }

    private func loadOrBuildSecondaryController(
        _ detailsViewContext: SearchDetailsViewContext?,
        appSkin: AppSkin
    ) -> SearchContainerSplitControllers.SecondaryController? {
        switch detailsViewContext {
        case let .detailedEntity(viewModel):
            return .anySizeClass(loadOrBuildDetailsController(viewModel,
                                                              appSkin: appSkin))
        case let .firstListedEntity(viewModel):
            return .regularOnly(loadOrBuildDetailsController(viewModel,
                                                             appSkin: appSkin))
        case .none:
            return nil
        }
    }

    private func loadOrBuildDetailsController(_ viewModel: SearchDetailsViewModel,
                                              appSkin: AppSkin) -> SearchDetailsViewController {
        guard let controller = existingDetailsController else {
            return buildSearchDetailsViewController(viewModel,
                                                    appSkin: appSkin)
        }

        controller.configure(viewModel)
        return controller
    }

}

private extension SearchPresenter {

    func existingPrimaryController<T: SearchPrimaryViewController>() -> T? {
        return searchContainerViewController.splitControllers.primaryController as? T
    }

    var existingDetailsController: SearchDetailsViewController? {
        return searchContainerViewController.splitControllers.secondaryController?.detailsController
    }

}

private extension SearchPresenter {

    func buildNoInternetViewController(_ viewModel: SearchNoInternetViewModel,
                                       titleViewModel: NavigationBarTitleViewModel,
                                       appSkin: AppSkin) -> SearchNoInternetViewController {
        let controller = SearchNoInternetViewController(viewModel: viewModel,
                                                        appSkin: appSkin)
        controller.configureTitleView(titleViewModel,
                                      appSkin: appSkin)
        return controller
    }

    func buildLocationServicesDisabledViewController(
        _ viewModel: SearchLocationDisabledViewModel,
        titleViewModel: NavigationBarTitleViewModel,
        appSkin: AppSkin
    ) -> SearchLocationDisabledViewController {
        let controller = SearchLocationDisabledViewController(viewModel: viewModel,
                                                              colorings: appSkin.colorings.searchCTA)
        controller.configureTitleView(titleViewModel,
                                      appSkin: appSkin)
        return controller
    }

    func buildSearchBackgroundViewController(_ viewModel: SearchBackgroundViewModel,
                                             titleViewModel: NavigationBarTitleViewModel,
                                             appSkin: AppSkin) -> SearchBackgroundViewController {
        let controller = SearchBackgroundViewController(viewModel: viewModel,
                                                        appSkin: appSkin)
        controller.configureTitleView(titleViewModel,
                                      appSkin: appSkin)
        return controller
    }

    func buildSearchParentViewController(
        _ viewModel: SearchLookupViewModel,
        titleViewModel: NavigationBarTitleViewModel,
        appSkin: AppSkin,
        searchInputBlock: @escaping SearchInputBlock
    ) -> SearchLookupParentController {
        let controller = SearchLookupParentController(store: store,
                                                      appSkin: appSkin,
                                                      viewModel: viewModel,
                                                      searchInputBlock: searchInputBlock)
        controller.configureTitleView(titleViewModel,
                                      appSkin: appSkin)
        controller.navigationItem.backBarButtonItem = appSkin.backButtonItem
        return controller
    }

    func buildSearchDetailsViewController(
        _ viewModel: SearchDetailsViewModel,
        appSkin: AppSkin
    ) -> SearchDetailsViewController {
        return SearchDetailsViewController(store: store,
                                           removeDetailedEntityAction: actionPrism.removeDetailedEntityAction,
                                           appSkin: appSkin,
                                           viewModel: viewModel)
    }

}
