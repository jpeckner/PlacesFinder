//
//  EntityReducerTests.swift
//  PlacesFinderTests
//
//  Created by Justin Peckner on 11/16/18.
//  Copyright © 2018 Justin Peckner. All rights reserved.
//

import Nimble
import Quick
import Shared
import SharedTestComponents
import SwiftDux
import SwiftDuxTestComponents

class EntityReducerTests: QuickSpec {

    // swiftlint:disable function_body_length
    // swiftlint:disable implicitly_unwrapped_optional
    override func spec() {

        describe("reduce") {

            let stubEntity = StubEntity.stubValue()

            context("when the action is not an EntityAction") {
                let currentState = EntityState<StubEntity>(loadState: .inProgress,
                                                           currentValue: nil)

                var resultState: EntityState<StubEntity>!

                beforeEach {
                    resultState = EntityReducer.reduce(action: StubAction.genericAction,
                                                       currentState: currentState)
                }

                it("returns the current state") {
                    expect(resultState) == currentState
                }
            }

            context("when the action is .inProgress") {
                let currentState = EntityState<StubEntity>(loadState: .idle,
                                                           currentValue: stubEntity)

                var resultState: EntityState<StubEntity>!

                beforeEach {
                    resultState = EntityReducer.reduce(action: EntityAction<StubEntity>.inProgress,
                                                       currentState: currentState)
                }

                it("returns the .inProgress loadState") {
                    expect(resultState.loadState) == .inProgress
                }

                it("returns the currentValue held previously") {
                    expect(resultState.currentValue) == stubEntity
                }
            }

            context("when the action is .success") {
                let currentState = EntityState<StubEntity>(loadState: .inProgress,
                                                           currentValue: stubEntity)
                let newValue = StubEntity(stringValue: "XYZ",
                                          intValue: 200,
                                          doubleValue: 7.5)

                var resultState: EntityState<StubEntity>!

                beforeEach {
                    resultState = EntityReducer.reduce(action: EntityAction<StubEntity>.success(newValue),
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
                let currentState = EntityState<StubEntity>(loadState: .inProgress,
                                                           currentValue: stubEntity)
                let entityError = EntityError.loadError(underlyingError: IgnoredEquatable(StubError.plainError))

                var resultState: EntityState<StubEntity>!

                beforeEach {
                    resultState = EntityReducer.reduce(
                        action: EntityAction<StubEntity>.failure(entityError),
                        currentState: currentState
                    )
                }

                it("returns the .failure loadState") {
                    expect(resultState.loadState) == .failure(entityError)
                }

                it("returns the currentValue held previously") {
                    expect(resultState.currentValue) == stubEntity
                }
            }

        }

    }

}
