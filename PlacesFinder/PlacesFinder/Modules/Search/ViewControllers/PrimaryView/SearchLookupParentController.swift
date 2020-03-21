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
    private let lookupView: SearchLookupView
    private let searchBarFullHeight: CGFloat
    private let searchBarHeightConstraint: NSLayoutConstraint

    private var viewModel: SearchLookupViewModel

    init(store: DispatchingStoreProtocol,
         viewModel: SearchLookupViewModel,
         appSkin: AppSkin) {
        self.store = store

        self.lookupView = SearchLookupView(contentViewModel: viewModel.searchInputViewModel.content,
                                           searchInputColorings: appSkin.colorings.searchInput) {
            viewModel.searchInputViewModel.callbacks.isEditing(.endedEditing)
        }

        let searchBarView = lookupView.searchBarWrapperView
        self.searchBarFullHeight = searchBarView.systemLayoutSizeFitting(UIView.layoutFittingCompressedSize).height
        self.searchBarHeightConstraint = searchBarView.heightAnchor.constraint(equalToConstant: searchBarFullHeight)
        searchBarHeightConstraint.isActive = true

        self.viewModel = viewModel

        super.init(contentView: lookupView,
                   viewColoring: appSkin.colorings.standard.viewColoring)

        lookupView.setSearchBarWrapperDelegate(self)
        configure(viewModel,
                  appSkin: appSkin)
    }

    required init?(coder aDecoder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }

}

extension SearchLookupParentController {

    func configure(_ viewModel: SearchLookupViewModel,
                   appSkin: AppSkin) {
        self.viewModel = viewModel
        self.viewColoring = appSkin.colorings.standard.viewColoring

        configureLookupView(viewModel.searchInputViewModel,
                            colorings: appSkin.colorings.searchInput)

        activateChildView(viewModel,
                          appSkin: appSkin)
    }

    private func configureLookupView(_ viewModel: SearchInputViewModel,
                                     colorings: SearchInputViewColorings) {
        searchBarHeightConstraint.constant =
            viewModel.content.isEditing ?
                searchBarFullHeight
                : searchBarHeightConstraint.constant

        lookupView.configure(viewModel.content,
                             colorings: colorings)
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
            lookupView.setChildView($0)
        }
    }

}

extension SearchLookupParentController: SearchBarWrapperDelegate {

    func searchBarWrapper(_ searchBarWrapper: SearchBarWrapper, didPerformAction action: SearchBarEditAction) {
        viewModel.searchInputViewModel.callbacks.isEditing(action)
    }

    func searchBarWrapper(_ searchBarWrapper: SearchBarWrapper, didClickSearch text: NonEmptyString) {
        let params = SearchParams(keywords: text)
        viewModel.searchInputViewModel.callbacks.lookup(params)
    }

}

extension SearchLookupParentController: SearchResultsViewControllerDelegate {

    func viewController(_ viewController: SearchResultsViewController, didScroll deltaY: CGFloat) {
        let updatedHeight = deltaY > 0 ?
            // Prevent setting constant < 0
            max(0.0, searchBarHeightConstraint.constant - deltaY)
            // Prevent setting constant > inputViewOriginalHeight
            : min(searchBarFullHeight, searchBarHeightConstraint.constant - deltaY)

        searchBarHeightConstraint.constant = updatedHeight
    }

}
