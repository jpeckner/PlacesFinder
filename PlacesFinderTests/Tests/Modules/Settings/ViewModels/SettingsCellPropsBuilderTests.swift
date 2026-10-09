//
//  SettingsCellPropsBuilderTests.swift
//  PlacesFinderTests
//
//  Copyright (c) 2020 Justin Peckner
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

import Foundation
import Nimble
import Quick
import Shared
import SharedTestComponents
import SwiftDux

// swiftlint:disable blanket_disable_command
// swiftlint:disable function_body_length
// swiftlint:disable implicitly_unwrapped_optional
class SettingsCellPropsBuilderTests: AsyncSpec {

    override class func spec() {

        var mockMeasurementFormatter: MeasurementFormatterProtocolMock!

        var sut: SettingsCellPropsBuilder!

        beforeEach {
            mockMeasurementFormatter = MeasurementFormatterProtocolMock()

            sut = SettingsCellPropsBuilder(measurementFormatter: mockMeasurementFormatter)
        }

        describe("buildDistanceCellProps()") {

            var results: [SettingsCellProps]!

            beforeEach {
                mockMeasurementFormatter.stringFromClosure = { value in
                    guard let measurement = value as? Measurement<UnitLength> else {
                        fail("Unexpected value found: \(value)")
                        return ""
                    }

                    return "stub_\(measurement.value)_\(measurement.unit.symbol)"
                }
            }

            func testMeasurmentSystem(_ searchDistances: [SearchDistance]) {
                for (caseIdx, currentDistanceType) in searchDistances.enumerated() {
                    context("when the current search distance is .\(currentDistanceType)") {

                        beforeEach {
                            results = sut.buildDistanceCellProps(
                                currentDistanceType: currentDistanceType,
                                colorings: AppColorings.defaultColorings.settings.cellColorings
                            )
                        }

                        it("has exactly one cell props per sorting option") {
                            expect(results.count) == searchDistances.count
                        }

                        it("has the title in each cell props as returned by mockMeasurementFormatter") {
                            for (idx, resultCellProps) in results.enumerated() {
                                let expectedMeasurement = searchDistances[idx].distanceType.measurement
                                expect(resultCellProps.title) ==
                                    "stub_\(expectedMeasurement.value)_\(expectedMeasurement.unit.symbol)"
                            }
                        }

                        it("has true as the value of isSelected for the current case") {
                            expect(results[caseIdx].isSelected) == true
                        }

                        it("has false as the value of isSelected for the other cases") {
                            for (idx, resultCellProps) in results.enumerated() where idx != caseIdx {
                                expect(resultCellProps.isSelected) == false
                            }
                        }

                        it("has the correct .setDistance action in each cell props") {
                            for (idx, resultCellProps) in results.enumerated() {
                                expect(resultCellProps.action.value) == .setDistance(searchDistances[idx])
                            }
                        }

                    }

                }
            }

            let allImperialSearchDistances: [SearchDistance] = SearchDistanceImperial.allCases.map { .imperial($0) }
            let allMetricSearchDistances: [SearchDistance] = SearchDistanceMetric.allCases.map { .metric($0) }

            context("when currentSearchDistance is .imperial") {
                testMeasurmentSystem(allImperialSearchDistances)
            }

            context("when currentSearchDistance is .metric") {
                testMeasurmentSystem(allMetricSearchDistances)
            }

        }

        describe("buildSortingCellProps()") {

            func expectedTitle(_ sorting: PlaceLookupSorting) -> String {
                switch sorting {
                case .bestMatch:
                    return L10n.SettingsSortPreference.bestMatchTitle
                case .distance:
                    return L10n.SettingsSortPreference.distanceTitle
                case .rating:
                    return L10n.SettingsSortPreference.ratingTitle
                case .reviewCount:
                    return L10n.SettingsSortPreference.reviewCountTitle
                }
            }

            var results: [SettingsCellProps]!

            for (caseIdx, currentSorting) in PlaceLookupSorting.allCases.enumerated() {

                context("when the current PlaceLookupSorting case is .\(currentSorting)") {

                    beforeEach {
                        results = sut.buildSortingCellProps(
                            currentSorting: currentSorting,
                            colorings: AppColorings.defaultColorings.settings.cellColorings
                        )
                    }

                    it("has exactly one cell props per sorting option") {
                        expect(results.count) == PlaceLookupSorting.allCases.count
                    }

                    it("has the correct title in each cell props") {
                        for (idx, resultCellProps) in results.enumerated() {
                            expect(resultCellProps.title) == expectedTitle(PlaceLookupSorting.allCases[idx])
                        }
                    }

                    it("has true as the value of isSelected for the current case") {
                        expect(results[caseIdx].isSelected) == true
                    }

                    it("has false as the value of isSelected for the other cases") {
                        for (idx, resultCellProps) in results.enumerated() where idx != caseIdx {
                            expect(resultCellProps.isSelected) == false
                        }
                    }

                    it("has the correct .setSorting action in each cell props") {
                        for (idx, resultCellProps) in results.enumerated() {
                            expect(resultCellProps.action.value) == .setSorting(PlaceLookupSorting.allCases[idx])
                        }
                    }

                }

            }

        }

    }

}
// swiftlint:enable blanket_disable_command
