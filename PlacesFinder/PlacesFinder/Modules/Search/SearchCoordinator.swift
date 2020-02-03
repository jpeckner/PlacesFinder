//
//  SearchCoordinator.swift
//  PlacesFinder
//
//  Created by Justin Peckner.
//  Copyright © 2018 Justin Peckner. All rights reserved.
//

import CoordiNode
import Shared
import SwiftDux
import UIKit

// sourcery: linkPayloadType = "EmptySearchLinkPayload"
// sourcery: linkPayloadType = "SearchLinkPayload"
class SearchCoordinator<TStore: StoreProtocol> where TStore.State == AppState {

    private let store: TStore
    private let presenter: SearchPresenterProtocol
    private let urlOpenerService: URLOpenerServiceProtocol
    private let copyFormatter: SearchCopyFormatterProtocol
    private let statePrism: SearchStatePrismProtocol
    private let actionPrism: SearchActionPrismProtocol

    init(store: TStore,
         presenter: SearchPresenterProtocol,
         urlOpenerService: URLOpenerServiceProtocol,
         copyFormatter: SearchCopyFormatterProtocol,
         statePrism: SearchStatePrismProtocol,
         actionPrism: SearchActionPrismProtocol) {
        self.store = store
        self.presenter = presenter
        self.urlOpenerService = urlOpenerService
        self.copyFormatter = copyFormatter
        self.statePrism = statePrism
        self.actionPrism = actionPrism

        let keyPaths = statePrism.presentationKeyPaths.union([
            EquatableKeyPath(\AppState.routerState),
        ])
        store.subscribe(self, equatableKeyPaths: keyPaths)
    }

}

extension SearchCoordinator: TabCoordinatorProtocol {

    var rootViewController: UIViewController {
        return presenter.rootViewController
    }

}

extension SearchCoordinator: SubstatesSubscriber {

    typealias StoreState = AppState

    func newState(state: AppState, updatedSubstates: Set<PartialKeyPath<AppState>>) {
        presentViews(state,
                     updatedSubstates: updatedSubstates)

        processLinkPayload(state)
    }

}

private extension SearchCoordinator {

    func presentViews(_ state: AppState,
                      updatedSubstates: Set<PartialKeyPath<AppState>>) {
        guard !updatedSubstates.isDisjoint(with: statePrism.presentationKeyPaths.partialKeyPaths) else {
            return
        }

        let appCopyContent = state.appCopyContentState.copyContent
        let titleViewModel = NavigationBarTitleViewModel(copyContent: appCopyContent.displayName)
        let appSkin = state.appSkinState.currentValue

        switch statePrism.presentationType(for: state) {
        case .noInternet:
            let viewModel = SearchNoInternetViewModel(copyContent: appCopyContent.searchNoInternet)
            presenter.loadNoInternetViews(viewModel,
                                          titleViewModel: titleViewModel,
                                          appSkin: appSkin)
        case .locationServicesDisabled:
            let viewModel = SearchLocationDisabledViewModel(urlOpenerService: urlOpenerService,
                                                            copyContent: appCopyContent.searchLocationDisabled)
            presenter.loadLocationServicesDisabledViews(viewModel,
                                                        titleViewModel: titleViewModel,
                                                        appSkin: appSkin)
        case let .search(authType):
            switch authType.value {
            case .locationServicesNotDetermined:
                let viewModel = SearchBackgroundViewModel(appCopyContent: appCopyContent)
                presenter.loadSearchBackgroundView(viewModel,
                                                   titleViewModel: titleViewModel,
                                                   appSkin: appSkin)
            case let .locationServicesEnabled(locationUpdateRequestBlock):
                let child = searchLookupChild(state.searchState.loadState,
                                              appCopyContent: appCopyContent,
                                              locationUpdateRequestBlock: locationUpdateRequestBlock)
                let viewModel = SearchLookupViewModel(searchState: state.searchState,
                                                      copyContent: appCopyContent.searchInput,
                                                      child: child) { [weak self] in
                    self?.submitInitalSearchRequest($0,
                                                    locationUpdateRequestBlock: locationUpdateRequestBlock)
                }
                let detailsContext = detailsViewContext(state,
                                                        appCopyContent: appCopyContent)

                presenter.loadSearchViews(viewModel,
                                          detailsViewContext: detailsContext,
                                          titleViewModel: titleViewModel,
                                          appSkin: appSkin)
            }
        }
    }

    func searchLookupChild(
        _ loadState: SearchLoadState,
        appCopyContent: AppCopyContent,
        locationUpdateRequestBlock: @escaping LocationUpdateRequestBlock
    ) -> SearchLookupViewModel.Child {
        switch loadState {
        case .idle:
            return .instructions(SearchInstructionsViewModel(copyContent: appCopyContent.searchInstructions))
        case .locationRequested,
             .initialPageRequested:
            return .progress
        case let .pagesReceived(submittedParams, _, allEntities, tokenContainer):
            let viewModel = resultViewModels(allEntities,
                                             resultsCopyContent: appCopyContent.searchResults)
            let refreshAction = initialRequestAction(submittedParams.keywords,
                                                     locationUpdateRequestBlock: locationUpdateRequestBlock)
            let nextRequestAction = tokenContainer.flatMap {
                try? actionPrism.subsequentRequestAction(submittedParams,
                                                         allEntities: allEntities,
                                                         tokenContainer: $0)
            }

            return .results(viewModel,
                            refreshAction: refreshAction,
                            nextRequestAction: nextRequestAction)
        case .noResultsFound:
            return .noResults(SearchNoResultsFoundViewModel(copyContent: appCopyContent.searchNoResults))
        case let .failure(submittedParams, _):
            return .failure(SearchRetryViewModel(copyContent: appCopyContent.searchRetry) { [weak self] in
                self?.submitInitalSearchRequest(submittedParams.keywords,
                                                locationUpdateRequestBlock: locationUpdateRequestBlock)
            })
        }
    }

    func resultViewModels(_ allEntities: NonEmptyArray<SearchEntityModel>,
                          resultsCopyContent: SearchResultsCopyContent) -> SearchResultsViewModel {
        let resultViewModels: NonEmptyArray<SearchResultViewModel> = allEntities.withTransformation {
            let cellModel = SearchResultCellModel(model: $0,
                                                  copyFormatter: copyFormatter,
                                                  resultsCopyContent: resultsCopyContent)
            let detailEntityAction = actionPrism.detailEntityAction($0)

            return SearchResultViewModel(cellModel: cellModel,
                                         detailEntityAction: detailEntityAction)
        }

        return SearchResultsViewModel(resultViewModels: resultViewModels)
    }

    func detailsViewContext(_ state: AppState,
                            appCopyContent: AppCopyContent) -> SearchDetailsViewContext? {
        return state.searchState.detailedEntity.map {
            .detailedEntity(SearchDetailsViewModel(entity: $0,
                                                   urlOpenerService: urlOpenerService,
                                                   copyFormatter: copyFormatter,
                                                   resultsCopyContent: appCopyContent.searchResults))
        }
        ?? state.searchState.entities?.value.first.map {
            .firstListedEntity(SearchDetailsViewModel(entity: $0,
                                                      urlOpenerService: urlOpenerService,
                                                      copyFormatter: copyFormatter,
                                                      resultsCopyContent: appCopyContent.searchResults))
        }
    }

}

private extension SearchCoordinator {

    func processLinkPayload(_ state: AppState) {
        switch statePrism.presentationType(for: state) {
        case .noInternet,
             .locationServicesDisabled:
            clearAllAssociatedLinkTypes(state, store: store)
        case let .search(authType):
            switch authType.value {
            case let .locationServicesNotDetermined(authBlock):
                guard isCurrentCoordinator(state) else { return }

                // Payload (if any for this coordinator) will be processed and cleared on the next state update
                authBlock()
            case let .locationServicesEnabled(requestBlock):
                guard let keywords = clearPayloadTypeIfPresent(state)?.keywords else {
                    clearAllAssociatedLinkTypes(state, store: store)
                    return
                }

                submitInitalSearchRequest(keywords,
                                          locationUpdateRequestBlock: requestBlock)
            }
        }
    }

    private func clearPayloadTypeIfPresent(_ state: AppState) -> SearchLinkPayload? {
        return clearPayloadTypeIfPresent(SearchLinkPayload.self,
                                         state: state,
                                         store: store)
    }

}

private extension SearchCoordinator {

    func submitInitalSearchRequest(_ keywords: NonEmptyString,
                                   locationUpdateRequestBlock: @escaping LocationUpdateRequestBlock) {
        store.dispatch(initialRequestAction(keywords,
                                            locationUpdateRequestBlock: locationUpdateRequestBlock))
    }

    func initialRequestAction(_ keywords: NonEmptyString,
                              locationUpdateRequestBlock: @escaping LocationUpdateRequestBlock) -> Action {
        return actionPrism.initialRequestAction(SearchSubmittedParams(keywords: keywords),
                                                locationUpdateRequestBlock: locationUpdateRequestBlock)
    }

}
