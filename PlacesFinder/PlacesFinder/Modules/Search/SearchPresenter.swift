//
//  SearchPresenter.swift
//  PlacesFinder
//
//  Created by Justin Peckner.
//  Copyright © 2018 Justin Peckner. All rights reserved.
//

import Shared
import SwiftDux
import UIKit

class SearchPresenter: SearchPresenterProtocol, SearchContainerPresenterProtocol {

    let searchContainerViewController: SearchContainerViewController

    var rootViewController: UIViewController {
        return searchContainerViewController
    }

    init(tabItemProperties: TabItemProperties) {
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

        existingController.configure(viewModel,
                                     colorings: appSkin.colorings.standard)
        existingController.configureTitleView(titleViewModel,
                                              appSkin: appSkin)
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

        existingController.configure(viewModel,
                                     colorings: appSkin.colorings.searchCTA)
        existingController.configureTitleView(titleViewModel,
                                              appSkin: appSkin)
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

        existingController.configure(viewModel,
                                     appSkin: appSkin)
        existingController.configureTitleView(titleViewModel,
                                              appSkin: appSkin)
    }

    func loadSearchViews(_ viewModel: SearchLookupViewModel,
                         detailsViewContext: SearchDetailsViewContext?,
                         titleViewModel: NavigationBarTitleViewModel,
                         appSkin: AppSkin) {
        let lookupController = loadOrBuildLookupController(viewModel,
                                                           titleViewModel: titleViewModel,
                                                           appSkin: appSkin)
        let secondaryController = loadOrBuildSecondaryController(detailsViewContext,
                                                                 appSkin: appSkin)

        searchContainerViewController.splitControllers = SearchContainerSplitControllers(
            primaryController: lookupController,
            secondaryController: secondaryController
        )
    }

}

private extension SearchPresenter {

    func buildNoInternetViewController(_ viewModel: SearchNoInternetViewModel,
                                       titleViewModel: NavigationBarTitleViewModel,
                                       appSkin: AppSkin) -> SearchNoInternetViewController {
        let controller = SearchNoInternetViewController(viewModel: viewModel,
                                                        colorings: appSkin.colorings.standard)
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

}
