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

    private func activateChildView(_ lookupViewModel: SearchLookupViewModel,
                                   appSkin: AppSkin) {
        switch lookupViewModel.child {
        case let .instructions(viewModel):
            setChildIfNotPresent(SearchInstructionsViewController.self) {
                SearchInstructionsViewController(viewModel: viewModel,
                                                 colorings: appSkin.colorings.standard)
            }
        case .progress:
            setChildIfNotPresent(SearchProgressViewController.self) {
                SearchProgressViewController(colorings: appSkin.colorings.searchProgress)
            }
        case let .results(viewModel, refreshAction, nextRequestAction):
            let resultsController = setChildIfNotPresent(SearchResultsViewController.self) {
                SearchResultsViewController(delegate: self,
                                            store: store,
                                            refreshAction: refreshAction,
                                            colorings: appSkin.colorings.searchResults,
                                            viewModel: viewModel,
                                            nextRequestAction: nextRequestAction)
            }

            resultsController.configure(viewModel,
                                        nextRequestAction: nextRequestAction)
        case let .noResults(viewModel):
            setChildIfNotPresent(SearchNoResultsFoundViewController.self) {
                SearchNoResultsFoundViewController(viewModel: viewModel,
                                                   colorings: appSkin.colorings.standard)
            }
        case let .failure(viewModel):
            setChildIfNotPresent(SearchRetryViewController.self) {
                SearchRetryViewController(viewModel: viewModel,
                                          colorings: appSkin.colorings.searchCTA)
            }
        }
    }

    @discardableResult
    private func setChildIfNotPresent<T: UIViewController>(_ type: T.Type, initBlock: () -> T) -> T {
        return setSingleChildIfNotPresent(type, initBlock: initBlock) {
            searchView.setChildView($0)
        }
    }

}
