//
//  AppState.swift
//  PlacesFinder
//
//  Created by Justin Peckner.
//  Copyright © 2018 Justin Peckner. All rights reserved.
//

import CoordiNode
import Foundation
import Shared
import SwiftDux

struct AppState: StateProtocol {
    let appCopyContentState: AppCopyContentState
    let appSkinState: AppSkinState
    let locationAuthState: LocationAuthState
    let reachabilityState: ReachabilityState
    let routerState: RouterState<AppLinkType>
    let searchPreferencesState: SearchPreferencesState
    let searchState: SearchState
}

extension AppState {

    init(appCopyContent: AppCopyContent,
         locationAuthStatus: LocationAuthStatus,
         currentRouterNode: NodeBox,
         searchPreferencesState: SearchPreferencesState) {
        self.appCopyContentState = AppCopyContentState(copyContent: appCopyContent)
        self.appSkinState = AppSkinState()
        self.locationAuthState = LocationAuthState(authStatus: locationAuthStatus)
        self.reachabilityState = ReachabilityState()
        self.routerState = RouterState(currentNode: currentRouterNode)
        self.searchPreferencesState = searchPreferencesState
        self.searchState = SearchState()
    }

}

enum AppStateReducer {

    static func reduce(action: Action,
                       appState: AppState) -> AppState {
        let appCopyContentState = AppCopyContentReducer.reduce(action: action,
                                                               currentState: appState.appCopyContentState)
        let appSkinState = AppSkinReducer.reduce(action: action,
                                                 currentState: appState.appSkinState)
        let locationAuthState = LocationAuthReducer.reduce(action: action,
                                                           currentState: appState.locationAuthState)
        let reachabilityState = ReachabilityReducer.reduce(action: action,
                                                           currentState: appState.reachabilityState)
        let routerState = RouterReducer.reduce(action: action,
                                               currentState: appState.routerState)
        let searchPreferencesState = SearchPreferencesReducer.reduce(action: action,
                                                                     currentState: appState.searchPreferencesState)
        let searchState = SearchReducer.reduce(action: action,
                                               currentState: appState.searchState)

        return AppState(appCopyContentState: appCopyContentState,
                        appSkinState: appSkinState,
                        locationAuthState: locationAuthState,
                        reachabilityState: reachabilityState,
                        routerState: routerState,
                        searchPreferencesState: searchPreferencesState,
                        searchState: searchState)
    }

}
