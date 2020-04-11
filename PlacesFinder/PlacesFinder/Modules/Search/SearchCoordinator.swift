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
    private let backgroundViewModelBuilder: SearchBackgroundViewModelBuilderProtocol
    private let lookupViewModelBuilder: SearchLookupViewModelBuilderProtocol

    init(store: TStore,
         presenter: SearchPresenterProtocol,
         urlOpenerService: URLOpenerServiceProtocol,
         copyFormatter: SearchCopyFormatterProtocol,
         statePrism: SearchStatePrismProtocol,
         actionPrism: SearchActionPrismProtocol,
         backgroundViewModelBuilder: SearchBackgroundViewModelBuilderProtocol,
         lookupViewModelBuilder: SearchLookupViewModelBuilderProtocol) {
        self.store = store
        self.presenter = presenter
        self.urlOpenerService = urlOpenerService
        self.copyFormatter = copyFormatter
        self.statePrism = statePrism
        self.actionPrism = actionPrism
        self.backgroundViewModelBuilder = backgroundViewModelBuilder
        self.lookupViewModelBuilder = lookupViewModelBuilder

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
        guard !updatedSubstates.isDisjoint(with: statePrism.presentationKeyPaths.partialKeyPaths) else { return }

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
                let viewModel = backgroundViewModelBuilder.buildViewModel(appCopyContent)
                presenter.loadSearchBackgroundView(viewModel,
                                                   titleViewModel: titleViewModel,
                                                   appSkin: appSkin)
            case let .locationServicesEnabled(locationUpdateRequestBlock):
                let viewModel = lookupViewModelBuilder.buildViewModel(
                    store,
                    actionPrism: actionPrism,
                    searchState: state.searchState,
                    appCopyContent: appCopyContent,
                    locationUpdateRequestBlock: locationUpdateRequestBlock
                )
                let detailsContext = SearchDetailsViewContext(searchState: state.searchState,
                                                              store: store,
                                                              actionPrism: actionPrism,
                                                              urlOpenerService: urlOpenerService,
                                                              copyFormatter: copyFormatter,
                                                              appCopyContent: appCopyContent)

                presenter.loadSearchViews(viewModel,
                                          detailsViewContext: detailsContext,
                                          titleViewModel: titleViewModel,
                                          appSkin: appSkin)
            }
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

                let params = SearchParams(keywords: keywords)
                submitInitalSearchRequest(params,
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

    func submitInitalSearchRequest(_ params: SearchParams,
                                   locationUpdateRequestBlock: @escaping LocationUpdateRequestBlock) {
        store.dispatch(initialRequestAction(params,
                                            locationUpdateRequestBlock: locationUpdateRequestBlock))
    }

    func initialRequestAction(_ params: SearchParams,
                              locationUpdateRequestBlock: @escaping LocationUpdateRequestBlock) -> Action {
        return actionPrism.initialRequestAction(params,
                                                locationUpdateRequestBlock: locationUpdateRequestBlock)
    }

}
