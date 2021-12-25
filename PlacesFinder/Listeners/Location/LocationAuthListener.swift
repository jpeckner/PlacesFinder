//
//  LocationAuthListener.swift
//  PlacesFinder
//
//  Created by Justin Peckner.
//  Copyright © 2018 Justin Peckner. All rights reserved.
//

import CoreLocation
import Shared
import SwiftDux

protocol LocationAuthListenerProtocol: AutoMockable {
    func start()
    func requestWhenInUseAuthorization()
}

class LocationAuthListener: NSObject {

    private let store: DispatchingStoreProtocol
    private let locationAuthManager: CLLocationManagerAuthProtocol
    private let assertionHandler: AssertionHandlerProtocol.Type

    init(store: DispatchingStoreProtocol,
         locationAuthManager: CLLocationManagerAuthProtocol,
         assertionHandler: AssertionHandlerProtocol.Type = AssertionHandler.self) {
        self.store = store
        self.locationAuthManager = locationAuthManager
        self.assertionHandler = assertionHandler
    }

}

extension LocationAuthListener: LocationAuthListenerProtocol {

    func start() {
        locationAuthManager.delegate = self
    }

    func requestWhenInUseAuthorization() {
        locationAuthManager.requestWhenInUseAuthorization()
    }

}

extension LocationAuthListener: CLLocationManagerDelegate {

    @objc
    func locationManager(_ manager: CLLocationManager, didChangeAuthorization status: CLAuthorizationStatus) {
        let loadState = status.authStatus(assertionHandler: assertionHandler)
        store.dispatch(loadState.locationAuthAction)
    }

}

private extension LocationAuthStatus {

    var locationAuthAction: LocationAuthAction {
        switch self {
        case .notDetermined:
            return .notDetermined
        case .locationServicesEnabled:
            return .locationServicesEnabled
        case .locationServicesDisabled:
            return .locationServicesDisabled
        }
    }

}
