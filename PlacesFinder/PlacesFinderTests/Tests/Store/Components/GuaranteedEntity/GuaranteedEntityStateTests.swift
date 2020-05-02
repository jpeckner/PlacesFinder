//
//  GuaranteedEntityStateTests.swift
//  PlacesFinder
//
//  Created by Justin Peckner.
//  Copyright © 2020 Justin Peckner. All rights reserved.
//

import Nimble
import Quick
import Shared
import SharedTestComponents

class GuaranteedEntityStateTests: QuickSpec {

    // swiftlint:disable function_body_length
    // swiftlint:disable implicitly_unwrapped_optional
    override func spec() {

        let stubValue: StubEntity = .stubValue()

        var result: StubGuaranteedEntityState!

        describe("init()") {

            beforeEach {
                result = StubGuaranteedEntityState()
            }

            it("returns loadState with a value of .idle") {
                expect(result.loadState) == .idle
            }

        }

        describe("currentValue") {

            context("when the loadState is .success") {
                beforeEach {
                    result = StubGuaranteedEntityState(loadState: .success(stubValue))
                }

                it("returns the value embedded in loadState") {
                    expect(result.currentValue) == stubValue
                    expect(result.currentValue) != StubGuaranteedEntityState.fallbackValue
                }
            }

            let fallbackLoadStates: [GuaranteedEntityLoadState<StubEntity>] = [
                .idle,
                .inProgress,
                .failure(.loadError(underlyingError: IgnoredEquatable(StubError.plainError)))
            ]

            for loadState in fallbackLoadStates {

                context("when the loadState is \(loadState)") {
                    beforeEach {
                        result = StubGuaranteedEntityState(loadState: loadState)
                    }

                    it("returns the fallback state value") {
                        expect(result.currentValue) == StubGuaranteedEntityState.fallbackValue
                    }
                }

            }

        }

        describe("hasCompletedLoading") {

            let nonFinishedStates: [GuaranteedEntityLoadState<StubEntity>] = [
                .idle,
                .inProgress,
            ]

            for loadState in nonFinishedStates {

                context("when the loadState is \(loadState)") {
                    beforeEach {
                        result = StubGuaranteedEntityState(loadState: loadState)
                    }

                    it("returns false") {
                        expect(result.hasCompletedLoading) == false
                    }
                }

            }

            let finishedStates: [GuaranteedEntityLoadState<StubEntity>] = [
                .success(stubValue),
                .failure(.loadError(underlyingError: IgnoredEquatable(StubError.plainError)))
            ]

            for loadState in finishedStates {

                context("when the loadState is \(loadState)") {
                    beforeEach {
                        result = StubGuaranteedEntityState(loadState: loadState)
                    }

                    it("returns true") {
                        expect(result.hasCompletedLoading) == true
                    }
                }

            }

        }

    }

}
