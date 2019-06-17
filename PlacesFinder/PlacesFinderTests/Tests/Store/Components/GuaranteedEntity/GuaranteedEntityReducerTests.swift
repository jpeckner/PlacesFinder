//
//  GuaranteedEntityReducerTests.swift
//  PlacesFinderTests
//
//  Created by Justin Peckner.
//  Copyright © 2018 Justin Peckner. All rights reserved.
//

import Nimble
#if DEBUG
@testable import PlacesFinder
#endif
import Quick
import Shared
import SharedTestComponents
import SwiftDuxTestComponents

private struct StubEntityState: GuaranteedEntityState, Equatable {
    typealias TEntity = StubEntity
    static let fallbackValue = StubEntity(stringValue: "FallbackValue",
                                          intValue: 10,
                                          doubleValue: 20.0)

    let loadState: GuaranteedEntityLoadState<TEntity>

    init(loadState: GuaranteedEntityLoadState<TEntity>) {
        self.loadState = loadState
    }
}

private typealias StubEntityReducer = GuaranteedEntityReducer<StubEntityState>

class GuaranteedEntityReducerTests: QuickSpec {

    // swiftlint:disable function_body_length
    // swiftlint:disable implicitly_unwrapped_optional
    override func spec() {

        describe("reduce") {

            var resultState: StubEntityState!

            context("when the action is not a GuaranteedEntityAction") {
                let currentState = StubEntityState(loadState: .inProgress)

                beforeEach {
                    resultState = StubEntityReducer.reduce(action: StubAction.genericAction,
                                                           currentState: currentState)
                }

                it("returns the current state") {
                    expect(resultState) == currentState
                }
            }

            context("when the action is .inProgress") {
                let currentState = StubEntityState(loadState: .idle)

                beforeEach {
                    resultState = StubEntityReducer.reduce(action: GuaranteedEntityAction<StubEntity>.inProgress,
                                                           currentState: currentState)
                }

                it("returns the .inProgress loadState") {
                    expect(resultState.loadState) == .inProgress
                }

                it("returns the fallbackValue for currentValue") {
                    expect(resultState.currentValue) == StubEntityState.fallbackValue
                }
            }

            context("when the action is .success") {
                let currentState = StubEntityState(loadState: .inProgress)
                let newValue = StubEntity(stringValue: "XYZ",
                                          intValue: 200,
                                          doubleValue: 7.5)

                beforeEach {
                    resultState = StubEntityReducer.reduce(action: GuaranteedEntityAction<StubEntity>.success(newValue),
                                                           currentState: currentState)
                }

                it("returns the .success loadState") {
                    expect(resultState.loadState) == .success(newValue)
                }

                it("returns the new entity as currentValue") {
                    expect(resultState.currentValue) == newValue
                }
            }

            context("when the action is .failure") {
                let currentState = StubEntityState(loadState: .inProgress)
                let entityError = EntityError.loadError(underlyingError: IgnoredEquatable(StubError.plainError))

                beforeEach {
                    let action = GuaranteedEntityAction<StubEntity>.failure(entityError)
                    resultState = StubEntityReducer.reduce(action: action,
                                                           currentState: currentState)
                }

                it("returns the .failure loadState") {
                    expect(resultState.loadState) == .failure(entityError)
                }

                it("returns the fallback value for currentValue") {
                    expect(resultState.currentValue) == StubEntityState.fallbackValue
                }
            }

        }

    }

}
