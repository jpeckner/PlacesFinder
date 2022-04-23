//
//  ReachabilityListenerTests.swift
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
import Nimble
import Quick
import SharedTestComponents
import SwiftDux

class ReachabilityListenerTests: QuickSpec {

    // swiftlint:disable implicitly_unwrapped_optional
    override func spec() {

        var receivedActions: [Action]!
        var cancellables: Set<AnyCancellable>!
        var mockReachability: ReachabilityProtocolMock!
        var listener: ReachabilityListener!

        beforeEach {
            receivedActions = []
            cancellables = []
            mockReachability = ReachabilityProtocolMock()
            listener = ReachabilityListener(reachability: mockReachability)

            listener.actionPublisher
                .sink { action in
                    receivedActions.append(action)
                }
                .store(in: &cancellables)
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
                    expect(receivedActions.last as? ReachabilityAction) == .reachable(.wifi)
                }
            }

            context("else when the reachability object calls back with .reachable(.cellular)") {
                beforeEach {
                    performTest(reachibilityStatus: .reachable(.cellular))
                }

                it("dispatches ReachabilityAction.reachable(.cellular)") {
                    expect(receivedActions.last as? ReachabilityAction) == .reachable(.cellular)
                }
            }

            context("else when the reachability object calls back with .unreachable") {
                beforeEach {
                    performTest(reachibilityStatus: .unreachable)
                }

                it("dispatches ReachabilityAction.unreachable") {
                    expect(receivedActions.last as? ReachabilityAction) == .unreachable
                }
            }

        }

    }

}
