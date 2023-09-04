//
//  LocationAuthListenerTests.swift
//  PlacesFinderTests
//
//  Copyright (c) 2019 Justin Peckner
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
import Nimble
import Quick
import Shared
import SharedTestComponents
import SwiftDux
import SwiftDuxTestComponents

// swiftlint:disable blanket_disable_command
// swiftlint:disable function_body_length
// swiftlint:disable implicitly_unwrapped_optional
class LocationAuthListenerTests: QuickSpec {

    override func spec() {

        let dummyLocationManager = CLLocationManager()

        var receivedActions: [LocationAuthAction]!
        var cancellables: Set<AnyCancellable>!
        var mockLocationAuthManager: CLLocationManagerAuthProtocolMock!
        var listener: LocationAuthListener!

        beforeEach {
            receivedActions = []
            cancellables = []
            mockLocationAuthManager = CLLocationManagerAuthProtocolMock()
            listener = LocationAuthListener(locationAuthManager: mockLocationAuthManager,
                                            assertionHandler: NoOpAssertionHandler.self)

            listener.actionPublisher
                .sink { action in
                    receivedActions.append(action)
                }
                .store(in: &cancellables)
        }

        describe("requestWhenInUseAuthorization") {
            beforeEach {
                listener.requestWhenInUseAuthorization()
            }

            it("calls mockLocationAuthManager.requestWhenInUseAuthorization()") {
                expect(mockLocationAuthManager.requestWhenInUseAuthorizationCalled) == true
            }
        }

        describe("didChangeAuthorization(:status)") {

            func performTest(_ status: CLAuthorizationStatus) {
                listener.locationManager(dummyLocationManager,
                                         didChangeAuthorization: status)
            }

            context("when didChangeAuthorization() is called with status .notDetermined") {
                beforeEach {
                    performTest(.notDetermined)
                }

                it("dispatches .notDetermined") {
                    expect(receivedActions.last) == .notDetermined
                }
            }

            context("when didChangeAuthorization() is called with status .authorizedAlways") {
                beforeEach {
                    performTest(.authorizedAlways)
                }

                it("dispatches .locationServicesEnabled") {
                    expect(receivedActions.last) == .locationServicesEnabled
                }
            }

            context("when didChangeAuthorization() is called with status .authorizedWhenInUse") {
                beforeEach {
                    performTest(.authorizedWhenInUse)
                }

                it("dispatches .locationServicesEnabled") {
                    expect(receivedActions.last) == .locationServicesEnabled
                }
            }

            context("when didChangeAuthorization() is called with status .denied") {
                beforeEach {
                    performTest(.denied)
                }

                it("dispatches .locationServicesDisabled") {
                    expect(receivedActions.last) == .locationServicesDisabled
                }
            }

            context("when didChangeAuthorization() is called with status .restricted") {
                beforeEach {
                    performTest(.restricted)
                }

                it("dispatches .locationServicesDisabled") {
                    expect(receivedActions.last) == .locationServicesDisabled
                }
            }

        }

    }

}
// swiftlint:enable blanket_disable_command
