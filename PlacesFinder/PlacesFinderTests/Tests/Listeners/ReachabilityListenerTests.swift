//
//  ReachabilityListenerTests.swift
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
import SharedTestComponents

class ReachabilityListenerTests: QuickSpec {

    // swiftlint:disable function_body_length
    // swiftlint:disable implicitly_unwrapped_optional
    override func spec() {

        var mockStore: MockAppStore!
        var mockReachability: ReachabilityProtocolMock!
        var listener: ReachabilityListener!

        beforeEach {
            mockStore = MockAppStore()
            mockReachability = ReachabilityProtocolMock()
            listener = ReachabilityListener(store: mockStore,
                                            reachability: mockReachability)
        }

        describe("start()") {

            var errorThrown: Error?

            func performTest(errorToThrow: Error?) {
                mockReachability.startNotifierThrowableError = errorToThrow
                errorThrown = errorThrownBy { try listener.start() }
            }

            it("calls reachability.setReachabilityCallback()") {
                performTest(errorToThrow: StubError.thrownError)
                expect(mockReachability.setReachabilityCallbackCallbackCalled) == true
            }

            it("calls reachability.startNotifier()") {
                performTest(errorToThrow: StubError.thrownError)
                expect(mockReachability.startNotifierCalled) == true
            }

            context("when startNotifier() throws an error") {
                beforeEach {
                    performTest(errorToThrow: StubError.thrownError)
                }

                it("rethrows the error") {
                    expect(errorThrown as? StubError) == .thrownError
                }
            }

            context("when startNotifier() does not throw an error") {
                beforeEach {
                    performTest(errorToThrow: nil)
                }

                it("does not throw an error") {
                    expect(errorThrown).to(beNil())
                }
            }

        }

        describe("callback") {

            func performTest(reachibilityStatus: ReachabilityStatus) {
                mockReachability.setReachabilityCallbackCallbackClosure = { callback in
                    callback(reachibilityStatus)
                }

                do {
                    try listener.start()
                } catch {
                    fail("Unexpected error: \(error)")
                }
            }

            context("when the reachability object calls back with .reachable(.wifi)") {
                beforeEach {
                    performTest(reachibilityStatus: .reachable(.wifi))
                }

                it("dispatches ReachabilityAction.reachable(.wifi)") {
                    expect(mockStore.dispatchedNonAsyncActions.last as? ReachabilityAction) == .reachable(.wifi)
                }
            }

            context("else when the reachability object calls back with .reachable(.cellular)") {
                beforeEach {
                    performTest(reachibilityStatus: .reachable(.cellular))
                }

                it("dispatches ReachabilityAction.reachable(.cellular)") {
                    expect(mockStore.dispatchedNonAsyncActions.last as? ReachabilityAction) == .reachable(.cellular)
                }
            }

            context("else when the reachability object calls back with .unreachable") {
                beforeEach {
                    performTest(reachibilityStatus: .unreachable)
                }

                it("dispatches ReachabilityAction.unreachable") {
                    expect(mockStore.dispatchedNonAsyncActions.last as? ReachabilityAction) == .unreachable
                }
            }

        }

    }

}
