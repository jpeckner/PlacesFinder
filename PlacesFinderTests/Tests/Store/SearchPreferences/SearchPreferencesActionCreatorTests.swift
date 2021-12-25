//
//  SearchPreferencesActionCreatorTests.swift
//  PlacesFinderTests
//
//  Created by Justin Peckner.
//  Copyright © 2019 Justin Peckner. All rights reserved.
//

import Nimble
import Quick
import SwiftDux

class SearchPreferencesActionCreatorTests: QuickSpec {

    // swiftlint:disable implicitly_unwrapped_optional
    override func spec() {

        describe("setMeasurementSystem()") {

            var result: Action!

            context("when the arg is .imperial") {
                beforeEach {
                    result = SearchPreferencesActionCreator.setMeasurementSystem(.imperial)
                }

                it("returns SearchPreferencesAction.setDistance, with a distance of ten miles") {
                    expect(result as? SearchPreferencesAction) == .setDistance(.imperial(.tenMiles))
                }
            }

            context("when the arg is .metric") {
                beforeEach {
                    result = SearchPreferencesActionCreator.setMeasurementSystem(.metric)
                }

                it("returns SearchPreferencesAction.setDistance, with a distance of twenty kilometers") {
                    expect(result as? SearchPreferencesAction) == .setDistance(.metric(.twentyKilometers))
                }
            }

        }

    }

}
