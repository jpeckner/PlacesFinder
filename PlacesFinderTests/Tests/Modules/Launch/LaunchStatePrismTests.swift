//
//  LaunchStatePrismTests.swift
//  PlacesFinderTests
//
//  Created by Justin Peckner.
//  Copyright © 2019 Justin Peckner. All rights reserved.
//

import Nimble
import Quick
import Shared
import SharedTestComponents
import SwiftDux
import SwiftDuxExtensions
import SwiftDuxTestComponents

class LaunchStatePrismTests: QuickSpec {

    // swiftlint:disable implicitly_unwrapped_optional
    override func spec() {

        var statePrism: LaunchStatePrism!

        beforeEach {
            statePrism = LaunchStatePrism()
        }

        describe("hasFinishedLaunching") {

            var result: Bool!

            context("when state.appSkinState.hasCompletedLoading is true") {
                beforeEach {
                    let underlyingError = EquatableError(SharedTestComponents.StubError.plainError)
                    let state = AppState.stubValue(
                        appSkinState: AppSkinState(loadState: .failure(.loadError(underlyingError: underlyingError)))
                    )
                    result = statePrism.hasFinishedLaunching(state)
                }

                it("returns true") {
                    expect(result) == true
                }
            }

            context("else") {
                beforeEach {
                    let state = AppState.stubValue(
                        appSkinState: AppSkinState(loadState: .idle)
                    )
                    result = statePrism.hasFinishedLaunching(state)
                }

                it("returns false") {
                    expect(result) == false
                }
            }

        }

    }

}
