//
//  SearchDistanceTests.swift
//  PlacesFinderTests
//
//  Created by Justin Peckner.
//  Copyright © 2019 Justin Peckner. All rights reserved.
//

import Nimble
import Quick
import Shared

class SearchDistanceTests: QuickSpec {

    // swiftlint:disable function_body_length
    // swiftlint:disable implicitly_unwrapped_optional
    override func spec() {

        describe("system") {

            var result: MeasurementSystem!

            context("when the case is .imperial") {
                beforeEach {
                    result = SearchDistance.imperial(.oneMile).system
                }

                it("returns MeasurementSystem.imperial") {
                    expect(result) == .imperial
                }
            }

            context("when the case is .metric") {
                beforeEach {
                    result = SearchDistance.metric(.fiveKilometers).system
                }

                it("returns MeasurementSystem.metric") {
                    expect(result) == .metric
                }
            }

        }

        describe("distanceType") {

            var result: SearchDistanceTypeProtocol!

            context("when the case is .imperial") {
                beforeEach {
                    result = SearchDistance.imperial(.oneMile).distanceType
                }

                it("returns the underlying SearchDistanceImperial value") {
                    expect(result as? SearchDistanceImperial) == .oneMile
                }
            }

            context("when the case is .metric") {
                beforeEach {
                    result = SearchDistance.metric(.fiveKilometers).distanceType
                }

                it("returns the underlying SearchDistanceMetric value") {
                    expect(result as? SearchDistanceMetric) == .fiveKilometers
                }
            }

        }

        describe("SearchDistanceImperial::measurement") {

            for distance in SearchDistanceImperial.allCases {
                let expectedMiles: Double
                switch distance {
                case .oneMile:
                    expectedMiles = 1
                case .fiveMiles:
                    expectedMiles = 5
                case .tenMiles:
                    expectedMiles = 10
                case .twentyMiles:
                    expectedMiles = 20
                }

                it("returns \(expectedMiles) miles as the measurement value") {
                    expect(distance.measurement) == Measurement<UnitLength>(value: expectedMiles, unit: .miles)
                }
            }

        }

        describe("SearchDistanceMetric::measurement") {

            for distance in SearchDistanceMetric.allCases {
                let expectedKilometers: Double
                switch distance {
                case .fiveKilometers:
                    expectedKilometers = 5
                case .tenKilometers:
                    expectedKilometers = 10
                case .twentyKilometers:
                    expectedKilometers = 20
                case .fortyKilometers:
                    expectedKilometers = 40
                }

                it("returns \(expectedKilometers) miles as the measurement value") {
                    expect(distance.measurement) == Measurement<UnitLength>(value: expectedKilometers,
                                                                            unit: .kilometers)
                }
            }

        }

    }

}
