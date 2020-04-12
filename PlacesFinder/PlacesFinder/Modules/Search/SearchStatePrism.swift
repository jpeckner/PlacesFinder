//
//  SearchStatePrism.swift
//  PlacesFinder
//
//  Created by Justin Peckner.
//  Copyright © 2019 Justin Peckner. All rights reserved.
//

import Foundation
import Shared
import SwiftDux

typealias LocationAuthRequestBlock = () -> Void
typealias LocationUpdateRequestBlock = (@escaping (LocationRequestResult) -> Void) -> Void

enum SearchPresentationType: Equatable {
    enum LocationServicesBlock {
        case locationServicesNotDetermined(authBlock: LocationAuthRequestBlock)
        case locationServicesEnabled(requestBlock: LocationUpdateRequestBlock)
    }

    case noInternet
    case locationServicesDisabled
    case search(IgnoredEquatable<LocationServicesBlock>)
}

protocol SearchStatePrismProtocol: AutoMockable {
    var presentationKeyPaths: Set<EquatableKeyPath<AppState>> { get }

    func presentationType(for state: AppState) -> SearchPresentationType
}

class SearchStatePrism: SearchStatePrismProtocol {

    let locationAuthListener: LocationAuthListenerProtocol
    let locationRequestHandler: LocationRequestHandlerProtocol

    init(locationAuthListener: LocationAuthListenerProtocol,
         locationRequestHandler: LocationRequestHandlerProtocol) {
        self.locationAuthListener = locationAuthListener
        self.locationRequestHandler = locationRequestHandler
    }

    var presentationKeyPaths: Set<EquatableKeyPath<AppState>> {
        return [
            EquatableKeyPath(\AppState.locationAuthState),
            EquatableKeyPath(\AppState.reachabilityState),
            EquatableKeyPath(\AppState.searchState),
        ]
    }

    func presentationType(for state: AppState) -> SearchPresentationType {
        if case .unreachable? = state.reachabilityState.status { return .noInternet }

        let locationAuthListener = self.locationAuthListener
        let locationRequestHandler = self.locationRequestHandler
        switch state.locationAuthState.authStatus {
        case .notDetermined:
            return .search(IgnoredEquatable(.locationServicesNotDetermined {
                locationAuthListener.requestWhenInUseAuthorization()
            }))
        case .locationServicesEnabled:
            return .search(IgnoredEquatable(.locationServicesEnabled { locationCallback in
                locationRequestHandler.requestLocation(locationCallback)
            }))
        case .locationServicesDisabled:
            return .locationServicesDisabled
        }
    }

}
