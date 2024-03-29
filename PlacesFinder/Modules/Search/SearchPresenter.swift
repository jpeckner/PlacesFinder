//
//  SearchPresenter.swift
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

import Shared
import SwiftDux
import UIKit

@MainActor
class SearchPresenter: SearchPresenterProtocol {

    private let searchContainerViewController: SearchContainerViewController

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

        existingController.configure(viewModel: viewModel)
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

        existingController.configure(viewModel: viewModel)
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

        existingController.configure(viewModel: viewModel)
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

    private func loadOrBuildLookupController(
        _ viewModel: SearchLookupViewModel,
        titleViewModel: NavigationBarTitleViewModel,
        appSkin: AppSkin
    ) -> SearchLookupParentController {
        guard let existingController: SearchLookupParentController = existingPrimaryController() else {
            return buildSearchParentViewController(viewModel,
                                                   titleViewModel: titleViewModel,
                                                   appSkin: appSkin)
        }

        existingController.configure(viewModel: viewModel)
        existingController.configureTitleView(titleViewModel,
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

        controller.configure(viewModel,
                             appSkin: appSkin)
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
        let controller = SearchNoInternetViewController(viewModel: viewModel)
        controller.configureTitleView(titleViewModel,
                                      appSkin: appSkin)
        return controller
    }

    func buildLocationServicesDisabledViewController(
        _ viewModel: SearchLocationDisabledViewModel,
        titleViewModel: NavigationBarTitleViewModel,
        appSkin: AppSkin
    ) -> SearchLocationDisabledViewController {
        let controller = SearchLocationDisabledViewController(viewModel: viewModel)
        controller.configureTitleView(titleViewModel,
                                      appSkin: appSkin)
        return controller
    }

    func buildSearchBackgroundViewController(_ viewModel: SearchBackgroundViewModel,
                                             titleViewModel: NavigationBarTitleViewModel,
                                             appSkin: AppSkin) -> SearchBackgroundViewController {
        let controller = SearchBackgroundViewController(viewModel: viewModel)
        controller.configureTitleView(titleViewModel,
                                      appSkin: appSkin)
        return controller
    }

    func buildSearchParentViewController(
        _ viewModel: SearchLookupViewModel,
        titleViewModel: NavigationBarTitleViewModel,
        appSkin: AppSkin
    ) -> SearchLookupParentController {
        let controller = SearchLookupParentController(viewModel: viewModel)
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
