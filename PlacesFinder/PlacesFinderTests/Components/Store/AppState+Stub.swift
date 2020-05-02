//
//  AppState+Stub.swift
//  PlacesFinderTests
//
//  Created by Justin Peckner.
//  Copyright © 2018 Justin Peckner. All rights reserved.
//

import CoordiNodeTestComponents
import SharedTestComponents

extension AppState {

    static func stubValue(
        appCopyContentState: AppCopyContentState = .init(copyContent: .stubValue()),
        appSkinState: AppSkinState = .init(),
        locationAuthState: LocationAuthState = .init(authStatus: .locationServicesDisabled),
        reachabilityState: ReachabilityState = .init(),
        routerState: RouterState<AppLinkType> = .init(currentNode: StubNode.nodeBox),
        searchPreferencesState: SearchPreferencesState = SearchPreferencesState(usesMetricSystem: true),
        searchState: SearchState = .init()
    ) -> AppState {
        return AppState(appCopyContentState: appCopyContentState,
                        appSkinState: appSkinState,
                        locationAuthState: locationAuthState,
                        reachabilityState: reachabilityState,
                        routerState: routerState,
                        searchPreferencesState: searchPreferencesState,
                        searchState: searchState)
    }

}
