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

protocol SearchPresenterProtocol: AutoMockable {
    var rootViewController: UIViewController { get }

    func loadNoInternetViews(_ state: AppState)
    func loadLocationServicesDisabledViews(_ state: AppState)
    func loadSearchBackgroundView(_ state: AppState)
    func loadSearchViews(_ state: AppState,
                         locationRequestBlock: @escaping LocationUpdateRequestBlock)
}

class SearchPresenter: SearchPresenterProtocol {

    private let store: DispatchingStoreProtocol
    private let actionPrism: SearchActionPrismProtocol
    private let urlOpenerService: URLOpenerServiceProtocol
    private let searchContainerViewController: SearchContainerViewController

    var rootViewController: UIViewController {
        return searchContainerViewController
    }

    init(store: DispatchingStoreProtocol,
         actionPrism: SearchActionPrismProtocol,
         urlOpenerService: URLOpenerServiceProtocol,
         tabItemProperties: TabItemProperties) {
        self.store = store
        self.actionPrism = actionPrism
        self.urlOpenerService = urlOpenerService
        self.searchContainerViewController = SearchContainerViewController()
        searchContainerViewController.configure(tabItemProperties)
    }

    func loadNoInternetViews(_ state: AppState) {
        let controller: SearchNoInternetViewController =
            (searchContainerViewController.splitControllers.primaryController as? SearchNoInternetViewController)
            ?? buildNoInternetViewController(state.appSkinState.currentValue,
                                             appCopyContent: state.appCopyContentState.copyContent)

        searchContainerViewController.splitControllers = SearchContainerSplitControllers(primaryController: controller,
                                                                                         secondaryController: nil)
    }

    func loadLocationServicesDisabledViews(_ state: AppState) {
        let controller: SearchLocationDisabledViewController =
            (searchContainerViewController.splitControllers.primaryController as? SearchLocationDisabledViewController)
            ?? buildLocationServicesDisabledViewController(state.appSkinState.currentValue,
                                                           appCopyContent: state.appCopyContentState.copyContent)

        searchContainerViewController.splitControllers = SearchContainerSplitControllers(primaryController: controller,
                                                                                         secondaryController: nil)
    }

    func loadSearchBackgroundView(_ state: AppState) {
        let controller: SearchBackgroundViewController =
            (searchContainerViewController.splitControllers.primaryController as? SearchBackgroundViewController)
            ?? buildSearchBackgroundViewController(state.appSkinState.currentValue,
                                                   appCopyContent: state.appCopyContentState.copyContent)

        searchContainerViewController.splitControllers = SearchContainerSplitControllers(primaryController: controller,
                                                                                         secondaryController: nil)
    }

    func loadSearchViews(_ state: AppState,
                         locationRequestBlock: @escaping LocationUpdateRequestBlock) {
        let appSkin = state.appSkinState.currentValue
        let appCopyContent = state.appCopyContentState.copyContent
        let copyFormatter = SearchCopyFormatter(resultsCopyContent: appCopyContent.searchResults)

        let searchParentController: SearchLookupParentController =
            (searchContainerViewController.splitControllers.primaryController as? SearchLookupParentController)
            ?? buildSearchParentViewController(appSkin,
                                               appCopyContent: appCopyContent,
                                               locationRequestBlock: locationRequestBlock)
        searchParentController.configure(state,
                                         appCopyContent: appCopyContent,
                                         resultsCopyFormatter: copyFormatter)

        let secondaryController: SearchContainerSplitControllers.SecondaryController? =
            state.searchState.detailedEntity.map {
                .anySizeClass(loadOrBuildDetailsController($0,
                                                           appSkin: appSkin,
                                                           copyFormatter: copyFormatter))
            }
            ?? state.searchState.entities?.value.first.map {
                .regularOnly(loadOrBuildDetailsController($0.detailsModel,
                                                          appSkin: appSkin,
                                                          copyFormatter: copyFormatter))
            }

        searchContainerViewController.splitControllers = SearchContainerSplitControllers(
            primaryController: searchParentController,
            secondaryController: secondaryController
        )
    }

    private func loadOrBuildDetailsController(
        _ detailsModel: SearchDetailsModel,
        appSkin: AppSkin,
        copyFormatter: SearchCopyFormatterProtocol
    ) -> SearchDetailsViewController {
        let controller =
            searchContainerViewController.splitControllers.secondaryController?.detailsController
            ?? buildSearchDetailsViewController(appSkin, copyFormatter: copyFormatter)
        controller.configure(detailsModel)
        return controller
    }

}

extension SearchPresenter {

    func buildNoInternetViewController(_ appSkin: AppSkin,
                                       appCopyContent: AppCopyContent) -> SearchNoInternetViewController {
        let controller = SearchNoInternetViewController(appSkin: appSkin,
                                                        appCopyContent: appCopyContent)
        controller.configureTitleView(appSkin,
                                      appCopyContent: appCopyContent)
        return controller
    }

    func buildLocationServicesDisabledViewController(
        _ appSkin: AppSkin,
        appCopyContent: AppCopyContent
    ) -> SearchLocationDisabledViewController {
        let controller = SearchLocationDisabledViewController(
            appSkin: appSkin,
            appCopyContent: appCopyContent,
            ctaType: urlOpenerService.openSettingsBlock.map { .cta(openSettingsBlock: $0) } ?? .noCTA
        )
        controller.configureTitleView(appSkin,
                                      appCopyContent: appCopyContent)
        return controller
    }

    func buildSearchBackgroundViewController(_ appSkin: AppSkin,
                                             appCopyContent: AppCopyContent) -> SearchBackgroundViewController {
        let controller = SearchBackgroundViewController(appSkin: appSkin,
                                                        appCopyContent: appCopyContent)
        controller.configureTitleView(appSkin,
                                      appCopyContent: appCopyContent)
        return controller
    }

    func buildSearchParentViewController(
        _ appSkin: AppSkin,
        appCopyContent: AppCopyContent,
        locationRequestBlock: @escaping LocationUpdateRequestBlock
    ) -> SearchLookupParentController {
        let controller = SearchLookupParentController(store: store,
                                                      actionPrism: actionPrism,
                                                      appSkin: appSkin,
                                                      appCopyContent: appCopyContent,
                                                      locationRequestBlock: locationRequestBlock)
        controller.configureTitleView(appSkin,
                                      appCopyContent: appCopyContent)
        controller.navigationItem.backBarButtonItem = appSkin.backButtonItem
        return controller
    }

    func buildSearchDetailsViewController(
        _ appSkin: AppSkin,
        copyFormatter: SearchCopyFormatterProtocol
    ) -> SearchDetailsViewController {
        return SearchDetailsViewController(store: store,
                                           actionPrism: actionPrism,
                                           urlOpenerService: urlOpenerService,
                                           copyFormatter: copyFormatter,
                                           appSkin: appSkin)
    }

}
