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
    private let statePrism: SearchStatePrismProtocol
    private let actionPrism: SearchActionPrismProtocol
    private let backgroundViewModelBuilder: SearchBackgroundViewModelBuilderProtocol
    private let lookupViewModelBuilder: SearchLookupViewModelBuilderProtocol
    private let detailsViewContextBuilder: SearchDetailsViewContextBuilderProtocol
    private let navigationBarViewModelBuilder: NavigationBarViewModelBuilderProtocol

    init(store: TStore,
         presenter: SearchPresenterProtocol,
         urlOpenerService: URLOpenerServiceProtocol,
         statePrism: SearchStatePrismProtocol,
         actionPrism: SearchActionPrismProtocol,
         backgroundViewModelBuilder: SearchBackgroundViewModelBuilderProtocol,
         lookupViewModelBuilder: SearchLookupViewModelBuilderProtocol,
         detailsViewContextBuilder: SearchDetailsViewContextBuilderProtocol,
         navigationBarViewModelBuilder: NavigationBarViewModelBuilderProtocol) {
        self.store = store
        self.presenter = presenter
        self.urlOpenerService = urlOpenerService
        self.statePrism = statePrism
        self.actionPrism = actionPrism
        self.backgroundViewModelBuilder = backgroundViewModelBuilder
        self.lookupViewModelBuilder = lookupViewModelBuilder
        self.detailsViewContextBuilder = detailsViewContextBuilder
        self.navigationBarViewModelBuilder = navigationBarViewModelBuilder

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
        let titleViewModel = navigationBarViewModelBuilder.buildTitleViewModel(copyContent: appCopyContent.displayName)
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
                let searchLinkPayload = currentNavigatingToDestinationPayload(SearchLinkPayload.self,
                                                                              state: state)
                let viewModel = backgroundViewModelBuilder.buildViewModel(searchLinkPayload?.keywords,
                                                                          appCopyContent: appCopyContent)
                presenter.loadSearchBackgroundView(viewModel,
                                                   titleViewModel: titleViewModel,
                                                   appSkin: appSkin)
            case let .locationServicesEnabled(locationUpdateRequestBlock):
                let viewModel = lookupViewModelBuilder.buildViewModel(
                    state.searchState,
                    appCopyContent: appCopyContent,
                    locationUpdateRequestBlock: locationUpdateRequestBlock
                )
                let detailsContext = detailsViewContextBuilder.buildViewContext(state.searchState,
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
                let searchLinkPayload = currentPayloadToBeCleared(SearchLinkPayload.self,
                                                                  state: state)
                clearAllAssociatedLinkTypes(state, store: store)

                searchLinkPayload.map {
                    let params = SearchParams(keywords: $0.keywords)
                    submitInitalSearchRequest(params,
                                              locationUpdateRequestBlock: requestBlock)
                }
            }
        }
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
