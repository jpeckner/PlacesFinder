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
@MainActor class SearchCoordinator<
    TAppStore: StoreProtocol,
    TSearchStore: StoreProtocol
> where TAppStore.TAction == AppAction, TAppStore.TState == AppState,
        TSearchStore.TAction == Search.Action, TSearchStore.TState == Search.State {

    private let appStoreRelay: SubstatesSubscriberRelay<TAppStore>
    private let searchStoreRelay: StoreSubscriptionRelay<TSearchStore>
    private let presenter: SearchPresenterProtocol
    private let urlOpenerService: URLOpenerServiceProtocol
    private let statePrism: SearchActivityStatePrismProtocol
    private let actionPrism: SearchActivityActionPrismProtocol
    private let backgroundViewModelBuilder: SearchBackgroundViewModelBuilderProtocol
    private let lookupViewModelBuilder: SearchLookupViewModelBuilderProtocol
    private let detailsViewContextBuilder: SearchDetailsViewContextBuilderProtocol
    private let navigationBarViewModelBuilder: NavigationBarViewModelBuilderProtocol

    private var cancellables: Set<Combine.AnyCancellable> = []

    init(appStoreRelay: SubstatesSubscriberRelay<TAppStore>,
         searchStoreRelay: StoreSubscriptionRelay<TSearchStore>,
         presenter: SearchPresenterProtocol,
         urlOpenerService: URLOpenerServiceProtocol,
         statePrism: SearchActivityStatePrismProtocol,
         actionPrism: SearchActivityActionPrismProtocol,
         backgroundViewModelBuilder: SearchBackgroundViewModelBuilderProtocol,
         lookupViewModelBuilder: SearchLookupViewModelBuilderProtocol,
         detailsViewContextBuilder: SearchDetailsViewContextBuilderProtocol,
         navigationBarViewModelBuilder: NavigationBarViewModelBuilderProtocol) {
        self.appStoreRelay = appStoreRelay
        self.searchStoreRelay = searchStoreRelay
        self.presenter = presenter
        self.urlOpenerService = urlOpenerService
        self.statePrism = statePrism
        self.actionPrism = actionPrism
        self.backgroundViewModelBuilder = backgroundViewModelBuilder
        self.lookupViewModelBuilder = lookupViewModelBuilder
        self.detailsViewContextBuilder = detailsViewContextBuilder
        self.navigationBarViewModelBuilder = navigationBarViewModelBuilder

        setupStoreRelays()
    }

    private func setupStoreRelays() {
        appStoreRelay.publisher
            .sink { [weak self] update in
                self?.searchStoreRelay.store.dispatch(.receiveState(IgnoredEquatable { [weak self] searchState in
                    self?.handleStateUpdate(appState: update.state,
                                            searchState: searchState)
                }))
            }
            .store(in: &cancellables)

        searchStoreRelay.publisher
            .sink { [weak self] searchState in
                self?.appStoreRelay.store.dispatch(.receiveState(IgnoredEquatable { [weak self] appState in
                    self?.handleStateUpdate(appState: appState,
                                            searchState: searchState)
                }))
            }
            .store(in: &cancellables)
    }

    private func handleStateUpdate(appState: AppState,
                                   searchState: Search.State) {
        Task { @MainActor in
            presentViews(appState: appState,
                         searchState: searchState)

            processLinkPayload(appState: appState)
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
            let viewModel = SearchNoInternetViewModel(
                copyContent: appCopyContent.searchNoInternet,
                colorings: appSkin.colorings.standard
            )
            presenter.loadNoInternetViews(viewModel,
                                          titleViewModel: titleViewModel,
                                          appSkin: appSkin)

        case .locationServicesDisabled:
            let viewModel = SearchLocationDisabledViewModel(urlOpenerService: urlOpenerService,
                                                            copyContent: appCopyContent.searchLocationDisabled,
                                                            colorings: appSkin.colorings.searchCTA)
            presenter.loadLocationServicesDisabledViews(viewModel,
                                                        titleViewModel: titleViewModel,
                                                        appSkin: appSkin)

        case let .search(authType):
            switch authType.value {
            case .locationServicesNotDetermined:
                let viewModel = backgroundViewModelBuilder.buildViewModel(
                    keywords: searchState.searchActivityState.inputParams.params?.keywords,
                    appCopyContent: appCopyContent,
                    colorings: appSkin.colorings.standard
                )
                presenter.loadSearchBackgroundView(viewModel,
                                                   titleViewModel: titleViewModel,
                                                   appSkin: appSkin)

            case let .locationServicesEnabled(locationUpdateRequestBlock):
                let viewModel = lookupViewModelBuilder.buildViewModel(
                    searchActivityState: searchState.searchActivityState,
                    appCopyContent: appCopyContent,
                    appSkin: appSkin,
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
                                        store: appStoreRelay.store)

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
                                            store: appStoreRelay.store)

                searchLinkPayload.map { payload in
                    let params = SearchParams(keywords: payload.keywords)
                    let action = actionPrism.initialRequestAction(searchParams: params,
                                                                  locationUpdateRequestBlock: requestBlock)
                    searchStoreRelay.store.dispatch(.searchActivity(action))
                }
            }
        }
    }

}
