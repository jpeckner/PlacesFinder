//
//  AppState.swift
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
import Foundation
import Shared
import SwiftDux

struct AppState: StateProtocol, Equatable {
    let appCopyContentState: AppCopyContentState
    let appSkinState: AppSkinState
    let locationAuthState: LocationAuthState
    let reachabilityState: ReachabilityState
    let routerState: RouterState<AppLinkType>
    let searchPreferencesState: SearchPreferencesState
    let searchActivityState: SearchActivityState
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
        self.searchActivityState = SearchActivityState()
    }

}

enum AppStateReducer {

    static func reduce(action: AppAction,
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
        let searchActivityState = SearchActivityReducer.reduce(action: action,
                                                               currentState: appState.searchActivityState)

        return AppState(appCopyContentState: appCopyContentState,
                        appSkinState: appSkinState,
                        locationAuthState: locationAuthState,
                        reachabilityState: reachabilityState,
                        routerState: routerState,
                        searchPreferencesState: searchPreferencesState,
                        searchActivityState: searchActivityState)
    }

}
