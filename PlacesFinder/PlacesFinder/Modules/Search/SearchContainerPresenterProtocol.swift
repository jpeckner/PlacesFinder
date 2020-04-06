//
//  SearchContainerPresenterProtocol.swift
//  PlacesFinder
//
//  Created by Justin Peckner.
//  Copyright © 2020 Justin Peckner. All rights reserved.
//

import SwiftDux

protocol SearchContainerPresenterProtocol {
    var searchContainerViewController: SearchContainerViewController { get }
}

extension SearchContainerPresenterProtocol {

    func loadOrBuildLookupController(
        _ viewModel: SearchLookupViewModel,
        titleViewModel: NavigationBarTitleViewModel,
        appSkin: AppSkin
    ) -> SearchLookupParentController {
        guard let existingController: SearchLookupParentController = existingPrimaryController() else {
            return buildSearchParentViewController(viewModel,
                                                   titleViewModel: titleViewModel,
                                                   appSkin: appSkin)
        }

        existingController.configure(viewModel,
                                     appSkin: appSkin)
        existingController.configureTitleView(titleViewModel,
                                              appSkin: appSkin)
        return existingController
    }

    func loadOrBuildSecondaryController(
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

        controller.configure(viewModel,
                             appSkin: appSkin)
        return controller
    }

}

extension SearchContainerPresenterProtocol {

    func existingPrimaryController<T: SearchPrimaryViewController>() -> T? {
        return searchContainerViewController.splitControllers.primaryController as? T
    }

    var existingDetailsController: SearchDetailsViewController? {
        return searchContainerViewController.splitControllers.secondaryController?.detailsController
    }

}

private extension SearchContainerPresenterProtocol {

    func buildSearchParentViewController(
        _ viewModel: SearchLookupViewModel,
        titleViewModel: NavigationBarTitleViewModel,
        appSkin: AppSkin
    ) -> SearchLookupParentController {
        let controller = SearchLookupParentController(viewModel: viewModel,
                                                      appSkin: appSkin)
        controller.configureTitleView(titleViewModel,
                                      appSkin: appSkin)
        controller.navigationItem.backBarButtonItem = appSkin.backButtonItem
        return controller
    }

    func buildSearchDetailsViewController(
        _ viewModel: SearchDetailsViewModel,
        appSkin: AppSkin
    ) -> SearchDetailsViewController {
        return SearchDetailsViewController(viewModel: viewModel,
                                           appSkin: appSkin)
    }

}
