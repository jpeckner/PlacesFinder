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
    private let statePrism: SearchStatePrismProtocol
    private let actionPrism: SearchInitialActionPrismProtocol

    init(store: TStore,
         presenter: SearchPresenterProtocol,
         statePrism: SearchStatePrismProtocol,
         actionPrism: SearchInitialActionPrismProtocol) {
        self.store = store
        self.presenter = presenter
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

    private func presentViews(_ state: AppState,
                              updatedSubstates: Set<PartialKeyPath<AppState>>) {
        guard !updatedSubstates.isDisjoint(with: statePrism.presentationKeyPaths.partialKeyPaths) else {
            return
        }

        switch statePrism.presentationType(for: state) {
        case .noInternet:
            presenter.loadNoInternetViews(state)
        case .locationServicesDisabled:
            presenter.loadLocationServicesDisabledViews(state)
        case let .search(authType):
            switch authType.value {
            case .locationServicesNotDetermined:
                presenter.loadSearchBackgroundView(state)
            case let .locationServicesEnabled(locationUpdateRequestBlock):
                presenter.loadSearchViews(state,
                                          locationUpdateRequestBlock: locationUpdateRequestBlock)
            }
        }
    }

    private func processLinkPayload(_ state: AppState) {
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

                requestInitialPage(keywords,
                                   locationUpdateRequestBlock: requestBlock)
            }
        }
    }

    @discardableResult
    private func clearPayloadTypeIfPresent(_ state: AppState) -> SearchLinkPayload? {
        return clearPayloadTypeIfPresent(SearchLinkPayload.self,
                                         state: state,
                                         store: store)
    }

    private func requestInitialPage(_ keywords: NonEmptyString,
                                    locationUpdateRequestBlock: @escaping LocationUpdateRequestBlock) {
        store.dispatch(actionPrism.initialRequestAction(SearchSubmittedParams(keywords: keywords),
                                                        locationUpdateRequestBlock: locationUpdateRequestBlock))
    }

}
