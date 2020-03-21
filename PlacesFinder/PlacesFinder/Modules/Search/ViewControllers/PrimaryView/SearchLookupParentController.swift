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
    private let searchViewWrapper: SearchLookupViewWrapper

    init(store: DispatchingStoreProtocol,
         viewModel: SearchLookupViewModel,
         appSkin: AppSkin) {
        self.store = store
        self.searchViewWrapper = SearchLookupViewWrapper(viewModel: viewModel,
                                                         searchInputColorings: appSkin.colorings.searchInput)

        super.init(contentView: searchViewWrapper.view,
                   viewColoring: appSkin.colorings.standard.viewColoring)

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
        self.viewColoring = appSkin.colorings.standard.viewColoring

        searchViewWrapper.configure(viewModel,
                                    appSkin: appSkin)

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
                    SearchResultsViewController(delegate: searchViewWrapper,
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
            searchViewWrapper.view.setChildView($0)
        }
    }

}

// MARK: SearchLookupViewWrapper

private class SearchLookupViewWrapper: NSObject {

    private enum TextEditState {
        case notEditing
        case editing(previous: String?)
        case exitedWithReturn
    }

    let view: SearchLookupView
    private var viewModel: SearchLookupViewModel
    private var editState: TextEditState
    private let searchBarFullHeight: CGFloat
    private let searchBarHeightConstraint: NSLayoutConstraint

    init(viewModel: SearchLookupViewModel,
         searchInputColorings: SearchInputViewColorings) {
        self.view = SearchLookupView(contentViewModel: viewModel.searchInputViewModel.content,
                                     searchInputColorings: searchInputColorings)

        self.viewModel = viewModel
        self.editState = .notEditing

        self.searchBarFullHeight = view.searchBar.systemLayoutSizeFitting(UIView.layoutFittingCompressedSize).height

        self.searchBarHeightConstraint = view.searchBar.heightAnchor.constraint(equalToConstant: searchBarFullHeight)
        searchBarHeightConstraint.isActive = true

        super.init()

        view.searchBar.delegate = self
        view.childContainerView.delegate = self
    }

    required init?(coder aDecoder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }

}

extension SearchLookupViewWrapper {

    func configure(_ viewModel: SearchLookupViewModel,
                   appSkin: AppSkin) {
        self.viewModel = viewModel

        view.configure(viewModel.searchInputViewModel.content,
                       colorings: appSkin.colorings.searchInput)
    }

}

extension SearchLookupViewWrapper: UISearchBarDelegate {

    func searchBarTextDidBeginEditing(_ searchBar: UISearchBar) {
        editState = .editing(previous: searchBar.text)
        handleTextFieldEditingState(true)
    }

    func searchBarTextDidEndEditing(_ searchBar: UISearchBar) {
        switch editState {
        case let .editing(previous):
            searchBar.text = previous
        case .exitedWithReturn:
            break
        case .notEditing:
            AssertionHandler.performAssertionFailure { "Unexpected editState value: \(editState)" }
        }

        editState = .notEditing
        handleTextFieldEditingState(false)
    }

    func searchBarSearchButtonClicked(_ searchBar: UISearchBar) {
        editState = .exitedWithReturn
        searchBar.resignFirstResponder()

        if let text = searchBar.text,
            let keywords = try? NonEmptyString(text) {
            let params = SearchParams(keywords: keywords)
            viewModel.searchInputViewModel.callbacks.lookup(params)
        } else {
            AssertionHandler.performAssertionFailure { "UISearchBar should be configured to not return empty text" }
        }
    }

    private func handleTextFieldEditingState(_ isEditing: Bool) {
        view.childContainerView.configureCoverView(isEditing)

        if isEditing {
            searchBarHeightConstraint.constant = searchBarFullHeight
        }
    }

}

extension SearchLookupViewWrapper: SearchChildContainerViewDelegate {

    func containerViewCoverWasTapped(_ containerView: SearchChildContainerView) {
        view.searchBar.resignFirstResponder()
    }

}

extension SearchLookupViewWrapper: SearchResultsViewControllerDelegate {

    func viewController(_ viewController: SearchResultsViewController, didScroll deltaY: CGFloat) {
        let updatedHeight = deltaY > 0 ?
            // Prevent setting constant < 0
            max(0.0, searchBarHeightConstraint.constant - deltaY)
            // Prevent setting constant > inputViewOriginalHeight
            : min(searchBarFullHeight, searchBarHeightConstraint.constant - deltaY)

        searchBarHeightConstraint.constant = updatedHeight
    }

}
