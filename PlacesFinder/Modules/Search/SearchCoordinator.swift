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

import Combine
import CoordiNode
import Shared
import SwiftDux
import UIKit

// sourcery: linkPayloadType = "EmptySearchLinkPayload"
// sourcery: linkPayloadType = "SearchLinkPayload"
class SearchCoordinator<TAppStore: StoreProtocol> where TAppStore.TAction == AppAction, TAppStore.TState == AppState {

    private let appStore: TAppStore
    private let appStoreRelay: SubstatesSubscriberRelay<TAppStore>
    private let presenter: SearchPresenterProtocol
    private let urlOpenerService: URLOpenerServiceProtocol
    private let statePrism: SearchActivityStatePrismProtocol
    private let actionPrism: SearchActivityActionPrismProtocol
    private let backgroundViewModelBuilder: SearchBackgroundViewModelBuilderProtocol
    private let lookupViewModelBuilder: SearchLookupViewModelBuilderProtocol
    private let detailsViewContextBuilder: SearchDetailsViewContextBuilderProtocol
    private let navigationBarViewModelBuilder: NavigationBarViewModelBuilderProtocol

    private let searchStore: Search.SearchStore
    private let searchStoreRelay: StoreSubscriptionRelay<Search.SearchStore>

    private var cancellables: Set<Combine.AnyCancellable> = []

    init(appStore: TAppStore,
         searchStore: Search.SearchStore,
         presenter: SearchPresenterProtocol,
         urlOpenerService: URLOpenerServiceProtocol,
         statePrism: SearchActivityStatePrismProtocol,
         actionPrism: SearchActivityActionPrismProtocol,
         backgroundViewModelBuilder: SearchBackgroundViewModelBuilderProtocol,
         lookupViewModelBuilder: SearchLookupViewModelBuilderProtocol,
         detailsViewContextBuilder: SearchDetailsViewContextBuilderProtocol,
         navigationBarViewModelBuilder: NavigationBarViewModelBuilderProtocol) {
        self.appStore = appStore
        self.searchStore = searchStore
        self.presenter = presenter
        self.urlOpenerService = urlOpenerService
        self.statePrism = statePrism
        self.actionPrism = actionPrism
        self.backgroundViewModelBuilder = backgroundViewModelBuilder
        self.lookupViewModelBuilder = lookupViewModelBuilder
        self.detailsViewContextBuilder = detailsViewContextBuilder
        self.navigationBarViewModelBuilder = navigationBarViewModelBuilder
        self.appStoreRelay = SubstatesSubscriberRelay(
            store: appStore,
            equatableKeyPaths: [
                EquatableKeyPath(\AppState.locationAuthState),
                EquatableKeyPath(\AppState.reachabilityState),
                EquatableKeyPath(\AppState.routerState)
            ]
        )
        self.searchStoreRelay = StoreSubscriptionRelay(store: searchStore)

        setupStoreRelays()
    }

    private func setupStoreRelays() {
        appStoreRelay.publisher
            .sink { [weak self] update in
                self?.searchStore.dispatch(.receiveState { [weak self] searchState in
                    self?.handleStateUpdate(appState: update.state,
                                            searchState: searchState)
                })
            }
            .store(in: &cancellables)

        searchStoreRelay.publisher
            .sink { [weak self] searchState in
                self?.appStore.dispatch(.receiveState { [weak self] appState in
                    self?.handleStateUpdate(appState: appState,
                                            searchState: searchState)
                })
            }
            .store(in: &cancellables)
    }

    private func handleStateUpdate(appState: AppState,
                                   searchState: Search.State) {
        DispatchQueue.main.async { [weak self] in
            self?.presentViews(appState: appState,
                               searchState: searchState)

            self?.processLinkPayload(appState: appState)
        }
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

private extension SearchCoordinator {

    func presentViews(appState: AppState,
                      searchState: Search.State) {
        let appCopyContent = appState.appCopyContentState.copyContent
        let titleViewModel = navigationBarViewModelBuilder.buildTitleViewModel(copyContent: appCopyContent.displayName)
        let appSkin = appState.appSkinState.currentValue
        let presentationType = statePrism.presentationType(locationAuthState: appState.locationAuthState,
                                                           reachabilityState: appState.reachabilityState)

        switch presentationType {
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
                let viewModel = backgroundViewModelBuilder.buildViewModel(
                    searchState.searchActivityState.inputParams.params?.keywords,
                    appCopyContent: appCopyContent
                )
                presenter.loadSearchBackgroundView(viewModel,
                                                   titleViewModel: titleViewModel,
                                                   appSkin: appSkin)

            case let .locationServicesEnabled(locationUpdateRequestBlock):
                let viewModel = lookupViewModelBuilder.buildViewModel(
                    searchState.searchActivityState,
                    appCopyContent: appCopyContent,
                    locationUpdateRequestBlock: locationUpdateRequestBlock
                )
                let detailsContext = detailsViewContextBuilder.buildViewContext(searchState.searchActivityState,
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

    func processLinkPayload(appState: AppState) {
        switch statePrism.presentationType(locationAuthState: appState.locationAuthState,
                                           reachabilityState: appState.reachabilityState) {
        case .noInternet,
             .locationServicesDisabled:
            clearAllAssociatedLinkTypes(appState,
                                        store: appStore)

        case let .search(authType):
            switch authType.value {
            case let .locationServicesNotDetermined(authBlock):
                // For clearer UX, only display the location auth block when this is the current coordinator
                guard isCurrentCoordinator(appState) else {
                    return
                }

                authBlock()

            case let .locationServicesEnabled(requestBlock):
                let searchLinkPayload = currentPayloadToBeCleared(SearchLinkPayload.self,
                                                                  state: appState)
                clearAllAssociatedLinkTypes(appState,
                                            store: appStore)

                searchLinkPayload.map { payload in
                    let params = SearchParams(keywords: payload.keywords)
                    searchStore.dispatch(actionPrism.initialRequestAction(params,
                                                                          locationUpdateRequestBlock: requestBlock))
                }
            }
        }
    }

}
