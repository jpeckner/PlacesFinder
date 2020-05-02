//
//  EntityStateTests.swift
//  PlacesFinderTests
//
//  Created by Justin Peckner.
//  Copyright © 2020 Justin Peckner. All rights reserved.
//

import Nimble
import Quick

class EntityStateTests: QuickSpec {

    // swiftlint:disable implicitly_unwrapped_optional
    override func spec() {

        var result: EntityState<StubEntity>!

        describe("init()") {

            beforeEach {
                result = EntityState()
            }

            it("returns loadState with a value of .idle") {
                expect(result.loadState) == .idle
            }

            it("returns currentValue with a value of nil") {
                expect(result.currentValue).to(beNil())
            }

        }

    }

}
