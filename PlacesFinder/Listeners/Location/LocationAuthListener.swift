//
//  LocationAuthListener.swift
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
import CoreLocation
import Shared
import SwiftDux

protocol LocationAuthListenerProtocol: AutoMockable {
    var actionPublisher: AnyPublisher<Action, Never> { get }

    func start()
    func requestWhenInUseAuthorization()
}

class LocationAuthListener: NSObject {

    var actionPublisher: AnyPublisher<Action, Never> {
        actionSubject.eraseToAnyPublisher()
    }

    private let locationAuthManager: CLLocationManagerAuthProtocol
    private let assertionHandler: AssertionHandlerProtocol.Type
    private let actionSubject = PassthroughSubject<Action, Never>()

    init(locationAuthManager: CLLocationManagerAuthProtocol,
         assertionHandler: AssertionHandlerProtocol.Type = AssertionHandler.self) {
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
        actionSubject.send(loadState.locationAuthAction)
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
