//
//  SearchCoordinator.swift
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
    private let statePrism: SearchActivityStatePrismProtocol
    private let actionPrism: SearchActivityActionPrismProtocol
    private let backgroundViewModelBuilder: SearchBackgroundViewModelBuilderProtocol
    private let lookupViewModelBuilder: SearchLookupViewModelBuilderProtocol
    private let detailsViewContextBuilder: SearchDetailsViewContextBuilderProtocol
    private let navigationBarViewModelBuilder: NavigationBarViewModelBuilderProtocol

    init(store: TStore,
         presenter: SearchPresenterProtocol,
         urlOpenerService: URLOpenerServiceProtocol,
         statePrism: SearchActivityStatePrismProtocol,
         actionPrism: SearchActivityActionPrismProtocol,
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

    func relinquishActive(completion: (() -> Void)?) {
        completion?()
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
                    state.searchActivityState,
                    appCopyContent: appCopyContent,
                    locationUpdateRequestBlock: locationUpdateRequestBlock
                )
                let detailsContext = detailsViewContextBuilder.buildViewContext(state.searchActivityState,
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
                    store.dispatch(actionPrism.initialRequestAction(params,
                                                                    locationUpdateRequestBlock: requestBlock))
                }
            }
        }
    }

}
