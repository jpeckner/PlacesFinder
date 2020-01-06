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
    private let actionPrism: SearchActionPrismProtocol
    private let copyFormatter: SearchCopyFormatterProtocol
    private let locationRequestBlock: LocationUpdateRequestBlock

    private let searchView: SearchLookupView

    init(store: DispatchingStoreProtocol,
         actionPrism: SearchActionPrismProtocol,
         copyFormatter: SearchCopyFormatterProtocol,
         appSkin: AppSkin,
         appCopyContent: AppCopyContent,
         locationRequestBlock: @escaping LocationUpdateRequestBlock) {
        self.store = store
        self.actionPrism = actionPrism
        self.copyFormatter = copyFormatter
        self.locationRequestBlock = locationRequestBlock
        self.searchView = SearchLookupView(searchInputViewModel: appCopyContent.searchInput.inputViewModel,
                                           searchInputColorings: appSkin.colorings.searchInput)

        super.init(contentView: searchView,
                   viewColoring: appSkin.colorings.standard.viewColoring)

        searchView.delegate = self
    }

    required init?(coder aDecoder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }

}

extension SearchLookupParentController {

    func submitSearchRequest(_ keywords: NonEmptyString) {
        store.dispatch(searchRequestAction(keywords))
    }

    private func searchRequestAction(_ keywords: NonEmptyString) -> Action {
        return actionPrism.initialRequestAction(SearchSubmittedParams(keywords: keywords),
                                                locationUpdateRequestBlock: locationRequestBlock)
    }

}

extension SearchLookupParentController: SearchResultsViewControllerDelegate {

    func viewController(_ viewController: SearchResultsViewController, didScroll deltaY: CGFloat) {
        searchView.childTableDidScroll(deltaY)
    }

}

extension SearchLookupParentController: SearchLookupViewDelegate {

    func searchView(_ searchView: SearchLookupView, didInputText text: NonEmptyString) {
        submitSearchRequest(text)
    }

}

extension SearchLookupParentController {

    func configure(_ state: AppState) {
        searchView.configure(state.searchState.submittedParams?.keywords)

        activateChildView(state.searchState.loadState,
                          appSkin: state.appSkinState.currentValue,
                          appCopyContent: state.appCopyContentState.copyContent)
    }

    private func activateChildView(_ loadState: SearchLoadState,
                                   appSkin: AppSkin,
                                   appCopyContent: AppCopyContent) {
        switch loadState {
        case .idle:
            setChildIfNotPresent(SearchInstructionsViewController.self) {
                SearchInstructionsViewController(colorings: appSkin.colorings.standard,
                                                 copyContent: appCopyContent.searchInstructions)
            }
        case .locationRequested,
             .initialPageRequested:
            setChildIfNotPresent(SearchProgressViewController.self) {
                SearchProgressViewController(colorings: appSkin.colorings.searchProgress)
            }
        case let .pagesReceived(submittedParams, _, allEntities, tokenContainer):
            setSearchResultsViewController(
                submittedParams,
                allEntities: allEntities,
                tokenContainer: tokenContainer,
                colorings: appSkin.colorings.searchResults,
                resultsCopyContent: appCopyContent.searchResults
            )
        case .noResultsFound:
            setChildIfNotPresent(SearchNoResultsFoundViewController.self) {
                SearchNoResultsFoundViewController(colorings: appSkin.colorings.standard,
                                                   copyContent: appCopyContent.searchNoResults)
            }
        case let .failure(submittedParams, _):
            setChildIfNotPresent(SearchRetryViewController.self) {
                SearchRetryViewController(colorings: appSkin.colorings.searchCTA,
                                          copyContent: appCopyContent.searchRetry) { [weak self] in
                    self?.submitSearchRequest(submittedParams.keywords)
                }
            }
        }
    }

    private func setSearchResultsViewController(_ submittedParams: SearchSubmittedParams,
                                                allEntities: NonEmptyArray<SearchEntityModel>,
                                                tokenContainer: PlaceLookupTokenAttemptsContainer?,
                                                colorings: SearchResultsViewColorings,
                                                resultsCopyContent: SearchResultsCopyContent) {
        let nextRequestAction = tokenContainer.flatMap {
            try? actionPrism.subsequentRequestAction(submittedParams,
                                                     allEntities: allEntities,
                                                     tokenContainer: $0)
        }
        let viewModels = resultViewModels(allEntities,
                                          resultsCopyContent: resultsCopyContent)

        let resultsController = setChildIfNotPresent(SearchResultsViewController.self) {
            SearchResultsViewController(delegate: self,
                                        store: store,
                                        refreshAction: searchRequestAction(submittedParams.keywords),
                                        colorings: colorings,
                                        nextRequestAction: nextRequestAction,
                                        resultViewModels: viewModels)
        }

        resultsController.configure(viewModels,
                                    nextRequestAction: nextRequestAction)
    }

    private func resultViewModels(_ allEntities: NonEmptyArray<SearchEntityModel>,
                                  resultsCopyContent: SearchResultsCopyContent) -> NonEmptyArray<SearchResultViewModel> {
        return allEntities.withTransformation {
            let cellModel = SearchResultCellModel(model: $0.summaryModel,
                                                  copyFormatter: copyFormatter,
                                                  resultsCopyContent: resultsCopyContent)
            let detailEntityAction = actionPrism.detailEntityAction($0.detailsModel)

            return SearchResultViewModel(cellModel: cellModel,
                                         detailEntityAction: detailEntityAction)
        }
    }

    @discardableResult
    private func setChildIfNotPresent<T: UIViewController>(_ type: T.Type, initBlock: () -> T) -> T {
        return setSingleChildIfNotPresent(type, initBlock: initBlock) {
            searchView.setChildView($0)
        }
    }

}
