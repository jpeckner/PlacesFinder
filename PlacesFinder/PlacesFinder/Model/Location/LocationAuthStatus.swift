//
//  LocationAuthStatus.swift
//  PlacesFinder
//
//  Created by Justin Peckner.
//  Copyright © 2019 Justin Peckner. All rights reserved.
//

import CoreLocation
import Shared

enum LocationAuthStatus {
    case notDetermined
    case locationServicesEnabled
    case locationServicesDisabled
}

extension CLAuthorizationStatus {

    func authStatus(assertionHandler: AssertionHandlerProtocol.Type = AssertionHandler.self) -> LocationAuthStatus {
        switch self {
        case .notDetermined:
            return .notDetermined
        case .authorizedAlways:
            assertionHandler.performAssertionFailure { "Unexpectedly received .authorizedAlways status" }
            fallthrough
        case .authorizedWhenInUse:
            return .locationServicesEnabled
        case .denied,
             .restricted:
            return .locationServicesDisabled
        @unknown default:
            fatalError("Unknown CLAuthorizationStatus case: \(self)")
        }
    }

}
