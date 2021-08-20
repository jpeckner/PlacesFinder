//
//  LocationAuthListenerTests.swift
//  PlacesFinderTests
//
//  Created by Justin Peckner.
//  Copyright © 2019 Justin Peckner. All rights reserved.
//

import CoreLocation
import Nimble
import Quick
import Shared
import SharedTestComponents
import SwiftDuxTestComponents

class LocationAuthListenerTests: QuickSpec {

    // swiftlint:disable function_body_length
    // swiftlint:disable implicitly_unwrapped_optional
    override func spec() {

        let dummyLocationManager = CLLocationManager()

        var mockStore: MockAppStore!
        var mockLocationAuthManager: CLLocationManagerAuthProtocolMock!
        var listener: LocationAuthListener!

        beforeEach {
            mockStore = MockAppStore()
            mockLocationAuthManager = CLLocationManagerAuthProtocolMock()
            listener = LocationAuthListener(store: mockStore,
                                            locationAuthManager: mockLocationAuthManager,
                                            assertionHandler: NoOpAssertionHandler.self)
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
                    expect(mockStore.dispatchedNonAsyncActions.last as? LocationAuthAction) == .notDetermined
                }
            }

            context("when didChangeAuthorization() is called with status .authorizedAlways") {
                beforeEach {
                    performTest(.authorizedAlways)
                }

                it("dispatches .locationServicesEnabled") {
                    expect(mockStore.dispatchedNonAsyncActions.last as? LocationAuthAction) == .locationServicesEnabled
                }
            }

            context("when didChangeAuthorization() is called with status .authorizedWhenInUse") {
                beforeEach {
                    performTest(.authorizedWhenInUse)
                }

                it("dispatches .locationServicesEnabled") {
                    expect(mockStore.dispatchedNonAsyncActions.last as? LocationAuthAction) == .locationServicesEnabled
                }
            }

            context("when didChangeAuthorization() is called with status .denied") {
                beforeEach {
                    performTest(.denied)
                }

                it("dispatches .locationServicesDisabled") {
                    expect(mockStore.dispatchedNonAsyncActions.last as? LocationAuthAction) == .locationServicesDisabled
                }
            }

            context("when didChangeAuthorization() is called with status .restricted") {
                beforeEach {
                    performTest(.restricted)
                }

                it("dispatches .locationServicesDisabled") {
                    expect(mockStore.dispatchedNonAsyncActions.last as? LocationAuthAction) == .locationServicesDisabled
                }
            }

        }

    }

}
