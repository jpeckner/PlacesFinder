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

// swiftlint:disable blanket_disable_command
// swiftlint:disable implicitly_unwrapped_optional
class ReachabilityListenerTests: QuickSpec {

    override func spec() {

        var receivedActions: [ReachabilityAction]!
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

            beforeEach {
                listener.start()
            }

            it("calls reachability.setReachabilityCallback()") {
                expect(mockReachability.setReachabilityCallbackCallbackCalled) == true
            }

            it("calls reachability.start()") {
                expect(mockReachability.startQueueCalled) == true
            }

        }

        describe("callback") {

            func performTest(reachibilityStatus: ReachabilityStatus) {
                mockReachability.setReachabilityCallbackCallbackClosure = { callback in
                    callback(reachibilityStatus)
                }

                listener.start()
            }

            context("when the reachability object calls back with .reachable") {
                beforeEach {
                    performTest(reachibilityStatus: .reachable)
                }

                it("dispatches ReachabilityAction.reachable") {
                    expect(receivedActions.last) == .reachable
                }
            }

            context("else when the reachability object calls back with .reachable") {
                beforeEach {
                    performTest(reachibilityStatus: .reachable)
                }

                it("dispatches ReachabilityAction.reachable)") {
                    expect(receivedActions.last) == .reachable
                }
            }

            context("else when the reachability object calls back with .unreachable") {
                beforeEach {
                    performTest(reachibilityStatus: .unreachable)
                }

                it("dispatches ReachabilityAction.unreachable") {
                    expect(receivedActions.last) == .unreachable
                }
            }

        }

    }

}
// swiftlint:enable blanket_disable_command
