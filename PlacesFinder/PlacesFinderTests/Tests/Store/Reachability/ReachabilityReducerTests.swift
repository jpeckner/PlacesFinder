//
//  ReachabilityReducerTests.swift
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
import SwiftDuxTestComponents

class ReachabilityReducerTests: QuickSpec {

    // swiftlint:disable implicitly_unwrapped_optional
    override func spec() {

        describe("reduce") {

            var result: ReachabilityState!

            context("when the action is not a ReachabilityAction") {
                let currentState = ReachabilityState(status: .unreachable)

                beforeEach {
                    result = ReachabilityReducer.reduce(action: StubAction.genericAction,
                                                        currentState: currentState)
                }

                it("returns the current state") {
                    expect(result) == currentState
                }
            }

            context("else when the action is ReachabilityAction.unreachable") {
                let currentState = ReachabilityState(status: .reachable(.wifi))

                beforeEach {
                    result = ReachabilityReducer.reduce(action: ReachabilityAction.unreachable,
                                                        currentState: currentState)
                }

                it("returns a state with status == .unreachable") {
                    expect(result) == ReachabilityState(status: .unreachable)
                }
            }

            context("else when the action is ReachabilityAction.reachable") {

                let currentState = ReachabilityState(status: .unreachable)

                context("and the action is .wifi") {
                    beforeEach {
                        result = ReachabilityReducer.reduce(action: ReachabilityAction.reachable(.wifi),
                                                            currentState: currentState)
                    }

                    it("returns a state with status == .reachable, type == .wifi") {
                        expect(result) == ReachabilityState(status: .reachable(.wifi))
                    }
                }

                context("else the action is .cellular") {
                    beforeEach {
                        result = ReachabilityReducer.reduce(action: ReachabilityAction.reachable(.cellular),
                                                            currentState: currentState)
                    }

                    it("returns a state with status == .reachable, type == .cellular") {
                        expect(result) == ReachabilityState(status: .reachable(.cellular))
                    }
                }

            }

        }

    }

}
