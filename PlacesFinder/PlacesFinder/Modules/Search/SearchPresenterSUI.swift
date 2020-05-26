//
//  SearchPresenterSUI.swift
//  PlacesFinder
//
//  Created by Justin Peckner.
//  Copyright © 2020 Justin Peckner. All rights reserved.
//

import Foundation
import Shared
import SwiftUI
import UIKit

protocol SearchPresenterProtocol: AutoMockable {
    var rootViewController: UIViewController { get }

    func loadNoInternetViews(_ viewModel: SearchNoInternetViewModel,
                             titleViewModel: NavigationBarTitleViewModel,
                             appSkin: AppSkin)

    func loadLocationServicesDisabledViews(_ viewModel: SearchLocationDisabledViewModel,
                                           titleViewModel: NavigationBarTitleViewModel,
                                           appSkin: AppSkin)

    func loadSearchBackgroundView(_ viewModel: SearchBackgroundViewModel,
                                  titleViewModel: NavigationBarTitleViewModel,
                                  appSkin: AppSkin)

    func loadSearchViews(_ viewModel: SearchLookupViewModel,
                         detailsViewContext: SearchDetailsViewContext?,
                         titleViewModel: NavigationBarTitleViewModel,
                         appSkin: AppSkin)
}

class SearchPresenterSUI: SearchPresenterProtocol {

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
        guard let existingController: SearchNoInternetController = existingPrimaryController() else {
            let hostingController = buildNoInternetViewController(viewModel,
                                                                  titleViewModel: titleViewModel,
                                                                  appSkin: appSkin)
            searchContainerViewController.splitControllers = SearchContainerSplitControllers(
                primaryController: hostingController,
                secondaryController: nil
            )
            return
        }

        existingController.rootView.configure(viewModel,
                                              colorings: appSkin.colorings.standard)
    }

    func loadLocationServicesDisabledViews(_ viewModel: SearchLocationDisabledViewModel,
                                           titleViewModel: NavigationBarTitleViewModel,
                                           appSkin: AppSkin) {
        guard let existingController: SearchLocationDisabledController = existingPrimaryController() else {
            let hostingController = buildLocationDisabledViewController(viewModel,
                                                                        titleViewModel: titleViewModel,
                                                                        appSkin: appSkin)
            searchContainerViewController.splitControllers = SearchContainerSplitControllers(
                primaryController: hostingController,
                secondaryController: nil
            )
            return
        }

        existingController.rootView.configure(viewModel,
                                              colorings: appSkin.colorings.searchCTA)
    }

    func loadSearchBackgroundView(_ viewModel: SearchBackgroundViewModel,
                                  titleViewModel: NavigationBarTitleViewModel,
                                  appSkin: AppSkin) {
        guard let existingController: SearchBackgroundController = existingPrimaryController() else {
            let hostingController = buildBackgroundViewController(viewModel,
                                                                  titleViewModel: titleViewModel,
                                                                  appSkin: appSkin)
            searchContainerViewController.splitControllers = SearchContainerSplitControllers(
                primaryController: hostingController,
                secondaryController: nil
            )
            return
        }

        existingController.rootView.configure(viewModel.instructionsViewModel,
                                              colorings: appSkin.colorings.standard)
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
    ) -> SearchLookupController {
        guard let existingController: SearchLookupController = existingPrimaryController() else {
            return buildLookupViewController(viewModel,
                                             titleViewModel: titleViewModel,
                                             appSkin: appSkin)
        }

        existingController.rootView.configure(viewModel,
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

        controller.rootView.configure(viewModel,
                                      colorings: appSkin.colorings.searchDetails)
        return controller
    }

}

private extension SearchPresenterSUI {

    func existingPrimaryController<T: SearchPrimaryViewController>() -> T? {
        return searchContainerViewController.splitControllers.primaryController as? T
    }

    var existingDetailsController: SearchDetailsViewController? {
        return searchContainerViewController.splitControllers.secondaryController?.detailsController
    }

}

private extension SearchPresenterSUI {

    typealias SearchNoInternetController = SearchPrimaryViewHostController<SearchNoInternetViewSUI>

    func buildNoInternetViewController(_ viewModel: SearchNoInternetViewModel,
                                       titleViewModel: NavigationBarTitleViewModel,
                                       appSkin: AppSkin) -> SearchNoInternetController {
        let view = SearchNoInternetViewSUI(viewModel: viewModel,
                                           colorings: appSkin.colorings.standard)
        return buildPrimaryHostController(view,
                                          titleViewModel: titleViewModel,
                                          appSkin: appSkin)
    }

    typealias SearchLocationDisabledController = SearchPrimaryViewHostController<SearchLocationDisabledViewSUI>

    func buildLocationDisabledViewController(_ viewModel: SearchLocationDisabledViewModel,
                                             titleViewModel: NavigationBarTitleViewModel,
                                             appSkin: AppSkin) -> SearchLocationDisabledController {
        let view = SearchLocationDisabledViewSUI(viewModel: viewModel,
                                                 colorings: appSkin.colorings.searchCTA)
        return buildPrimaryHostController(view,
                                          titleViewModel: titleViewModel,
                                          appSkin: appSkin)
    }

    typealias SearchBackgroundController = SearchPrimaryViewHostController<SearchInstructionsViewSUI>

    func buildBackgroundViewController(_ viewModel: SearchBackgroundViewModel,
                                       titleViewModel: NavigationBarTitleViewModel,
                                       appSkin: AppSkin) -> SearchBackgroundController {
        let view = SearchInstructionsViewSUI(viewModel: viewModel.instructionsViewModel,
                                             colorings: appSkin.colorings.standard)
        return buildPrimaryHostController(view,
                                          titleViewModel: titleViewModel,
                                          appSkin: appSkin)
    }

    typealias SearchLookupController = SearchPrimaryViewHostController<SearchLookupViewSUI>

    func buildLookupViewController(_ viewModel: SearchLookupViewModel,
                                   titleViewModel: NavigationBarTitleViewModel,
                                   appSkin: AppSkin) -> SearchLookupController {
        let view = SearchLookupViewSUI(viewModel: viewModel,
                                       appSkin: appSkin)
        return buildPrimaryHostController(view,
                                          titleViewModel: titleViewModel,
                                          appSkin: appSkin)
    }

    func buildSearchDetailsViewController(
        _ viewModel: SearchDetailsViewModel,
        appSkin: AppSkin
    ) -> SearchDetailsViewController {
        let view = SearchDetailsViewSUI(viewModel: viewModel,
                                        colorings: appSkin.colorings.searchDetails)
        return UIHostingController(rootView: view)
    }

}

private extension SearchPresenterSUI {

    func buildPrimaryHostController<TView: View>(_ view: TView,
                                                 titleViewModel: NavigationBarTitleViewModel,
                                                 appSkin: AppSkin) -> SearchPrimaryViewHostController<TView> {
        let hostingController = SearchPrimaryViewHostController(rootView: view)
        hostingController.configureTitleView(titleViewModel,
                                             appSkin: appSkin)
        return hostingController
    }

}

private class SearchPrimaryViewHostController<TView: View>: UIHostingController<TView>,
                                                            SearchPrimaryViewControllerProtocol {}
