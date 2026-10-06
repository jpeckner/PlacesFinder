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

    func loadNoInternetViews(_ props: SearchNoInternetViewProps,
                             titleProps: NavigationBarTitleViewProps,
                             appSkin: AppSkin) {
        guard let existingController: SearchNoInternetViewController = existingPrimaryController() else {
            let controller = buildNoInternetViewController(props,
                                                           titleProps: titleProps,
                                                           appSkin: appSkin)
            searchContainerViewController.splitControllers = SearchContainerSplitControllers(
                primaryController: controller,
                secondaryController: nil
            )
            return
        }

        existingController.configure(props: props)
        existingController.configureTitleView(titleProps,
                                              appSkin: appSkin)
    }

    func loadLocationServicesDisabledViews(_ props: SearchLocationDisabledViewProps,
                                           titleProps: NavigationBarTitleViewProps,
                                           appSkin: AppSkin) {
        guard let existingController: SearchLocationDisabledViewController = existingPrimaryController() else {
            let controller = buildLocationServicesDisabledViewController(props,
                                                                         titleProps: titleProps,
                                                                         appSkin: appSkin)
            searchContainerViewController.splitControllers = SearchContainerSplitControllers(
                primaryController: controller,
                secondaryController: nil
            )
            return
        }

        existingController.configure(props: props)
        existingController.configureTitleView(titleProps,
                                              appSkin: appSkin)
    }

    func loadSearchBackgroundView(_ props: SearchBackgroundViewProps,
                                  titleProps: NavigationBarTitleViewProps,
                                  appSkin: AppSkin) {
        guard let existingController: SearchBackgroundViewController = existingPrimaryController() else {
            let controller = buildSearchBackgroundViewController(props,
                                                                 titleProps: titleProps,
                                                                 appSkin: appSkin)
            searchContainerViewController.splitControllers = SearchContainerSplitControllers(
                primaryController: controller,
                secondaryController: nil
            )
            return
        }

        existingController.configure(props: props)
        existingController.configureTitleView(titleProps,
                                              appSkin: appSkin)
    }

    func loadSearchViews(_ props: SearchLookupProps,
                         viewModel: SearchViewModel,
                         detailsViewContext: SearchDetailsViewContext?,
                         titleProps: NavigationBarTitleViewProps,
                         appSkin: AppSkin) {
        let lookupController = loadOrBuildLookupController(props,
                                                           viewModel: viewModel,
                                                           titleProps: titleProps,
                                                           appSkin: appSkin)
        let secondaryController = loadOrBuildSecondaryController(
            detailsViewContext,
            appSkin: appSkin
        ) { [weak viewModel] searchAction in
            viewModel?.dispatchAction(searchAction)
        }

        searchContainerViewController.splitControllers = SearchContainerSplitControllers(
            primaryController: lookupController,
            secondaryController: secondaryController
        )
    }

    private func loadOrBuildLookupController(
        _ props: SearchLookupProps,
        viewModel: SearchViewModel,
        titleProps: NavigationBarTitleViewProps,
        appSkin: AppSkin
    ) -> SearchLookupParentController {
        guard let existingController: SearchLookupParentController = existingPrimaryController() else {
            return buildSearchParentViewController(props,
                                                   viewModel: viewModel,
                                                   titleProps: titleProps,
                                                   appSkin: appSkin)
        }

        existingController.configure(props: props)
        existingController.configureTitleView(titleProps,
                                              appSkin: appSkin)
        return existingController
    }

    private func loadOrBuildSecondaryController(
        _ detailsViewContext: SearchDetailsViewContext?,
        appSkin: AppSkin,
        actionTriggered: @escaping (Search.Action) -> Void
    ) -> SearchContainerSplitControllers.SecondaryController? {
        switch detailsViewContext {
        case let .detailedEntity(props):
            return .anySizeClass(loadOrBuildDetailsController(props,
                                                              appSkin: appSkin,
                                                              actionTriggered: actionTriggered))
        case let .firstListedEntity(props):
            return .regularOnly(loadOrBuildDetailsController(props,
                                                             appSkin: appSkin,
                                                             actionTriggered: actionTriggered))
        case .none:
            return nil
        }
    }

    private func loadOrBuildDetailsController(
        _ props: SearchDetailsProps,
        appSkin: AppSkin,
        actionTriggered: @escaping (Search.Action) -> Void
    ) -> SearchDetailsViewController {
        guard let controller = existingDetailsController else {
            return buildSearchDetailsViewController(props,
                                                    appSkin: appSkin,
                                                    actionTriggered: actionTriggered)
        }

        controller.configure(props,
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

    func buildNoInternetViewController(_ props: SearchNoInternetViewProps,
                                       titleProps: NavigationBarTitleViewProps,
                                       appSkin: AppSkin) -> SearchNoInternetViewController {
        let controller = SearchNoInternetViewController(props: props)
        controller.configureTitleView(titleProps,
                                      appSkin: appSkin)
        return controller
    }

    func buildLocationServicesDisabledViewController(
        _ props: SearchLocationDisabledViewProps,
        titleProps: NavigationBarTitleViewProps,
        appSkin: AppSkin
    ) -> SearchLocationDisabledViewController {
        let controller = SearchLocationDisabledViewController(props: props)
        controller.configureTitleView(titleProps,
                                      appSkin: appSkin)
        return controller
    }

    func buildSearchBackgroundViewController(_ props: SearchBackgroundViewProps,
                                             titleProps: NavigationBarTitleViewProps,
                                             appSkin: AppSkin) -> SearchBackgroundViewController {
        let controller = SearchBackgroundViewController(props: props)
        controller.configureTitleView(titleProps,
                                      appSkin: appSkin)
        return controller
    }

    func buildSearchParentViewController(
        _ props: SearchLookupProps,
        viewModel: SearchViewModel,
        titleProps: NavigationBarTitleViewProps,
        appSkin: AppSkin
    ) -> SearchLookupParentController {
        let controller = SearchLookupParentController(
            props: props,
            viewModel: viewModel
        )
        controller.configureTitleView(titleProps,
                                      appSkin: appSkin)
        controller.navigationItem.backBarButtonItem = appSkin.backButtonItem
        return controller
    }

    func buildSearchDetailsViewController(
        _ props: SearchDetailsProps,
        appSkin: AppSkin,
        actionTriggered: @escaping (Search.Action) -> Void
    ) -> SearchDetailsViewController {
        return SearchDetailsViewController(props: props,
                                           appSkin: appSkin,
                                           actionTriggered: actionTriggered)
    }

}
