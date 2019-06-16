//
//  SearchStatePrismTests.swift
//  PlacesFinderTests
//
//  Created by Justin Peckner.
//  Copyright © 2019 Justin Peckner. All rights reserved.
//

import Nimble
#if DEBUG
@testable import PlacesFinder
#endif
import Quick
import Shared
import SharedTestComponents
import SwiftDux
import SwiftDuxTestComponents

class SearchStatePrismTests: QuickSpec {

    // swiftlint:disable function_body_length
    // swiftlint:disable implicitly_unwrapped_optional
    override func spec() {

        var mockLocationAuthListener: LocationAuthListenerProtocolMock!
        var mockLocationRequestHandler: LocationRequestHandlerProtocolMock!
        var statePrism: SearchStatePrism!

        beforeEach {
            mockLocationAuthListener = LocationAuthListenerProtocolMock()
            mockLocationRequestHandler = LocationRequestHandlerProtocolMock()

            statePrism = SearchStatePrism(locationAuthListener: mockLocationAuthListener,
                                          locationRequestHandler: mockLocationRequestHandler)
        }

        describe("presentationKeyPaths") {

            it("returns its expected value") {
                expect(statePrism.presentationKeyPaths) == [
                    EquatableKeyPath(\AppState.locationAuthState),
                    EquatableKeyPath(\AppState.reachabilityState),
                    EquatableKeyPath(\AppState.searchState),
                ]
            }

        }

        describe("presentationType") {

            var result: SearchPresentationType!

            context("when state.reachabilityState has a status of .unreachable") {
                beforeEach {
                    let state = AppState.stubValue(
                        locationAuthState: LocationAuthState(authStatus: .locationServicesDisabled),
                        reachabilityState: ReachabilityState(status: .unreachable)
                    )
                    result = statePrism.presentationType(for: state)
                }

                it("returns .noInternet") {
                    expect(result) == .noInternet
                }
            }

            context("else when state.locationAuthState has a status of .locationServicesDisabled") {
                beforeEach {
                    let state = AppState.stubValue(
                        locationAuthState: LocationAuthState(authStatus: .locationServicesDisabled),
                        reachabilityState: ReachabilityState(status: nil)
                    )
                    result = statePrism.presentationType(for: state)
                }

                it("returns .locationServicesDisabled") {
                    expect(result) == .locationServicesDisabled
                }
            }

            context("else when state.locationAuthState has a status of .notDetermined") {
                beforeEach {
                    let state = AppState.stubValue(
                        locationAuthState: LocationAuthState(authStatus: .notDetermined),
                        reachabilityState: ReachabilityState(status: nil)
                    )
                    result = statePrism.presentationType(for: state)
                }

                it("returns .search(.locationServicesNotDetermined), with a block for requesting .whenInUse auth") {
                    guard case let .search(blockType)? = result,
                        case let .locationServicesNotDetermined(block) = blockType.value
                    else {
                        fail("Unexpected value: \(String(describing: result))")
                        return
                    }

                    expect(mockLocationAuthListener.requestWhenInUseAuthorizationCalled) == false
                    block()
                    expect(mockLocationAuthListener.requestWhenInUseAuthorizationCalled) == true
                }
            }

            context("else when state.locationAuthState has a status of .locationServicesEnabled") {
                beforeEach {
                    let state = AppState.stubValue(
                        locationAuthState: LocationAuthState(authStatus: .locationServicesEnabled),
                        reachabilityState: ReachabilityState(status: nil)
                    )
                    result = statePrism.presentationType(for: state)
                }

                it("returns .search(.locationServicesEnabled), with a block for requesting a location update") {
                    guard case let .search(blockType)? = result,
                        case let .locationServicesEnabled(block) = blockType.value
                    else {
                        fail("Unexpected value: \(String(describing: result))")
                        return
                    }

                    expect(mockLocationRequestHandler.requestLocationCalled) == false
                    block { _ in }
                    expect(mockLocationRequestHandler.requestLocationCalled) == true
                }
            }

        }

    }

}
