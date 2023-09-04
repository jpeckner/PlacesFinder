//
//  SearchActivityStatePrismTests.swift
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

import Nimble
import Quick
import Shared
import SharedTestComponents
import SwiftDux
import SwiftDuxTestComponents

// swiftlint:disable blanket_disable_command
// swiftlint:disable implicitly_unwrapped_optional
class SearchActivityStatePrismTests: QuickSpec {

    override func spec() {

        var mockLocationAuthListener: LocationAuthListenerProtocolMock!
        var mockLocationRequestHandler: LocationRequestHandlerProtocolMock!
        var statePrism: SearchActivityStatePrism!

        beforeEach {
            mockLocationAuthListener = LocationAuthListenerProtocolMock()
            mockLocationRequestHandler = LocationRequestHandlerProtocolMock()
            mockLocationRequestHandler.requestLocationReturnValue = .success(.stubValue())

            statePrism = SearchActivityStatePrism(locationAuthRequester: mockLocationAuthListener,
                                                  locationRequestHandler: mockLocationRequestHandler)
        }

        describe("presentationType") {

            var result: SearchPresentationType!

            context("when state.reachabilityState has a status of .unreachable") {
                beforeEach {
                    result = statePrism.presentationType(
                        locationAuthState: LocationAuthState(authStatus: .locationServicesDisabled),
                        reachabilityState: ReachabilityState(status: .unreachable)
                    )
                }

                it("returns .noInternet") {
                    expect(result) == .noInternet
                }
            }

            context("else when state.locationAuthState has a status of .locationServicesDisabled") {
                beforeEach {
                    result = statePrism.presentationType(
                        locationAuthState: LocationAuthState(authStatus: .locationServicesDisabled),
                        reachabilityState: ReachabilityState(status: .reachable)
                    )
                }

                it("returns .locationServicesDisabled") {
                    expect(result) == .locationServicesDisabled
                }
            }

            context("else when state.locationAuthState has a status of .notDetermined") {
                beforeEach {
                    result = statePrism.presentationType(
                        locationAuthState: LocationAuthState(authStatus: .notDetermined),
                        reachabilityState: ReachabilityState(status: .reachable)
                    )
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
                    result = statePrism.presentationType(
                        locationAuthState: LocationAuthState(authStatus: .locationServicesEnabled),
                        reachabilityState: ReachabilityState(status: .reachable)
                    )
                }

                it("returns .search(.locationServicesEnabled), with a block for requesting a location update") {
                    guard case let .search(blockType)? = result,
                        case let .locationServicesEnabled(block) = blockType.value
                    else {
                        fail("Unexpected value: \(String(describing: result))")
                        return
                    }

                    expect(mockLocationRequestHandler.requestLocationCalled) == false
                    _ = await block()
                    expect(mockLocationRequestHandler.requestLocationCalled) == true
                }
            }

        }

    }

}
// swiftlint:enable blanket_disable_command
