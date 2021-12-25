//
//  LaunchStatePrismTests.swift
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
