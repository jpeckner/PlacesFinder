//
//  SearchLookupParentController.swift
//  PlacesFinder
//
//  Created by Justin Peckner.
//  Copyright © 2018 Justin Peckner. All rights reserved.
//

import Shared
import SwiftDux
import UIKit

class SearchLookupParentController: SingleContentViewController, SearchPrimaryViewControllerProtocol {

    private let store: DispatchingStoreProtocol
    private let searchView: SearchLookupView
    private var viewModel: SearchLookupViewModel

    init(store: DispatchingStoreProtocol,
         viewModel: SearchLookupViewModel,
         appSkin: AppSkin) {
        self.store = store
        self.viewModel = viewModel
        self.searchView = SearchLookupView(searchInputViewModel: viewModel.searchInputViewModel,
                                           searchInputColorings: appSkin.colorings.searchInput)

        super.init(contentView: searchView,
                   viewColoring: appSkin.colorings.standard.viewColoring)

        searchView.delegate = self
        configure(viewModel,
                  appSkin: appSkin)
    }

    required init?(coder aDecoder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }

}

extension SearchLookupParentController: SearchResultsViewControllerDelegate {

    func viewController(_ viewController: SearchResultsViewController, didScroll deltaY: CGFloat) {
        searchView.childTableDidScroll(deltaY)
    }

}

extension SearchLookupParentController: SearchLookupViewDelegate {

    func searchView(_ searchView: SearchLookupView, didInputText text: NonEmptyString) {
        viewModel.lookupBlock(text)
    }

}

extension SearchLookupParentController {

    func configure(_ viewModel: SearchLookupViewModel,
                   appSkin: AppSkin) {
        self.viewColoring = appSkin.colorings.standard.viewColoring
        self.viewModel = viewModel

        searchView.configure(viewModel.searchInputViewModel,
                             colorings: appSkin.colorings.searchInput)

        activateChildView(viewModel,
                          appSkin: appSkin)
    }

    // swiftlint:disable function_body_length
    private func activateChildView(_ lookupViewModel: SearchLookupViewModel,
                                   appSkin: AppSkin) {
        switch lookupViewModel.child {
        case let .instructions(viewModel):
            let colorings = appSkin.colorings.standard
            guard let existingController: SearchInstructionsViewController = existingChildController() else {
                setSingleChildController(
                    SearchInstructionsViewController(viewModel: viewModel,
                                                     colorings: colorings)
                )
                return
            }

            existingController.configure(viewModel,
                                         colorings: colorings)
        case .progress:
            let colorings = appSkin.colorings.searchProgress
            guard let existingController: SearchProgressViewController = existingChildController() else {
                setSingleChildController(
                    SearchProgressViewController(colorings: colorings)
                )
                return
            }

            existingController.configure(colorings)
        case let .results(viewModel, refreshAction, nextRequestAction):
            let colorings = appSkin.colorings.searchResults
            guard let existingController: SearchResultsViewController = existingChildController() else {
                setSingleChildController(
                    SearchResultsViewController(delegate: self,
                                                store: store,
                                                refreshAction: refreshAction,
                                                colorings: colorings,
                                                viewModel: viewModel,
                                                nextRequestAction: nextRequestAction)
                )
                return
            }

            existingController.configure(viewModel,
                                         nextRequestAction: nextRequestAction,
                                         colorings: colorings)
        case let .noResults(viewModel):
            let colorings = appSkin.colorings.standard
            guard let existingController: SearchNoResultsFoundViewController = existingChildController() else {
                setSingleChildController(
                    SearchNoResultsFoundViewController(viewModel: viewModel,
                                                       colorings: colorings)
                )
                return
            }

            existingController.configure(viewModel,
                                         colorings: colorings)
        case let .failure(viewModel):
            let colorings = appSkin.colorings.searchCTA
            guard let existingController: SearchRetryViewController = existingChildController() else {
                setSingleChildController(
                    SearchRetryViewController(viewModel: viewModel,
                                              colorings: colorings)
                )
                return
            }

            existingController.configure(viewModel,
                                         colorings: colorings)
        }
    }
    // swiftlint:enable function_body_length

    private func existingChildController<T: UIViewController>() -> T? {
        return firstChild as? T
    }

    private func setSingleChildController(_ controller: UIViewController) {
        setSingleChildController(controller) {
            searchView.setChildView($0)
        }
    }

}
