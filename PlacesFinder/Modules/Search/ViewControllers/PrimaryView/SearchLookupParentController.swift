//
//  SearchLookupParentController.swift
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
import UIKit

class SearchLookupParentController: SingleContentViewController, SearchPrimaryViewControllerProtocol {

    private let lookupView: SearchLookupView
    private let searchBarFullHeight: CGFloat
    private let searchBarHeightConstraint: NSLayoutConstraint

    init(viewModel: SearchLookupViewModel,
         appSkin: AppSkin) {
        self.lookupView = SearchLookupView(inputViewModel: viewModel.searchInputViewModel)

        let searchBarView = lookupView.searchBarWrapperView
        self.searchBarFullHeight = searchBarView.systemLayoutSizeFitting(UIView.layoutFittingCompressedSize).height
        self.searchBarHeightConstraint = searchBarView.heightAnchor.constraint(equalToConstant: searchBarFullHeight)
        searchBarHeightConstraint.isActive = true

        super.init(contentView: lookupView,
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

        configureLookupView(viewModel.searchInputViewModel)

        activateChildView(viewModel,
                          appSkin: appSkin)
    }

    private func configureLookupView(_ viewModel: SearchInputViewModel) {
        searchBarHeightConstraint.constant = viewModel.content.barState.isSearchInputVisible ?
            searchBarFullHeight
            : searchBarHeightConstraint.constant

        lookupView.configure(viewModel)
    }

    private func activateChildView(_ lookupViewModel: SearchLookupViewModel,
                                   appSkin: AppSkin) {
        switch lookupViewModel.child {
        case let .instructions(viewModel):
            guard let existingController: SearchInstructionsViewController = existingChildController() else {
                setSingleChildController(
                    SearchInstructionsViewController(viewModel: viewModel)
                )
                return
            }

            existingController.instructionsView.viewModel.value = viewModel
        case .progress:
            let colorings = appSkin.colorings.searchProgress
            guard let existingController: SearchProgressViewController = existingChildController() else {
                setSingleChildController(
                    SearchProgressViewController(colorings: colorings)
                )
                return
            }

            existingController.configure(colorings)
        case let .results(viewModel):
            let colorings = appSkin.colorings.searchResults
            guard let existingController: SearchResultsViewController = existingChildController() else {
                let resultsController = SearchResultsViewController(viewModel: viewModel,
                                                                    colorings: colorings)
                resultsController.delegate = self
                setSingleChildController(resultsController)
                return
            }

            existingController.configure(viewModel,
                                         colorings: colorings)
        case let .noResults(viewModel):
            guard let existingController: SearchNoResultsFoundViewController = existingChildController() else {
                setSingleChildController(
                    SearchNoResultsFoundViewController(viewModel: viewModel)
                )
                return
            }

            existingController.configure(viewModel: viewModel)
        case let .failure(viewModel):
            guard let existingController: SearchRetryViewController = existingChildController() else {
                setSingleChildController(
                    SearchRetryViewController(viewModel: viewModel)
                )
                return
            }

            existingController.configure(viewModel: viewModel)
        }
    }

    private func existingChildController<T: UIViewController>() -> T? {
        return firstChild as? T
    }

    private func setSingleChildController(_ controller: UIViewController) {
        setSingleChildController(controller) {
            lookupView.setChildView($0)
        }
    }

}

extension SearchLookupParentController: SearchResultsViewControllerDelegate {

    @MainActor
    func viewController(_ viewController: SearchResultsViewController, didScroll deltaY: CGFloat) {
        let updatedHeight = deltaY > 0 ?
            // Prevent setting constant < 0
            max(0.0, searchBarHeightConstraint.constant - deltaY)
            // Prevent setting constant > inputViewOriginalHeight
            : min(searchBarFullHeight, searchBarHeightConstraint.constant - deltaY)

        searchBarHeightConstraint.constant = updatedHeight
    }

}
