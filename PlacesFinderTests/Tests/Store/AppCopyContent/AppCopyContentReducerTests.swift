//
//  AppCopyContentReducerTests.swift
//  PlacesFinderTests
//
//  Created by Justin Peckner.
//  Copyright © 2020 Justin Peckner. All rights reserved.
//

import Nimble
import Quick
import SwiftDuxTestComponents

class AppCopyContentReducerTests: QuickSpec {

    // swiftlint:disable implicitly_unwrapped_optional
    override func spec() {

        describe("init()") {

            let currentState = AppCopyContentState(copyContent: .stubValue())
            var newState: AppCopyContentState!

            beforeEach {
                newState = AppCopyContentReducer.reduce(action: StubAction.genericAction,
                                                        currentState: currentState)
            }

            it("returns the current state") {
                expect(newState) == currentState
            }

        }

    }

}
