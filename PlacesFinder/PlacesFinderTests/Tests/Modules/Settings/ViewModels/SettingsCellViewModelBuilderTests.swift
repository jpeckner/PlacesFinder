//
//  SettingsCellViewModelBuilderTests.swift
//  PlacesFinder
//
//  Created by Justin Peckner.
//  Copyright © 2020 Justin Peckner. All rights reserved.
//

import Nimble
#if DEBUG
@testable import PlacesFinder
#endif
import Quick
import Shared
import SharedTestComponents
import SwiftDux
import SwiftDuxTestComponents

class SettingsCellViewModelBuilderTests: QuickSpec {

    // swiftlint:disable function_body_length
    // swiftlint:disable implicitly_unwrapped_optional
    // swiftlint:disable line_length
    override func spec() {

        var mockStore: MockAppStore!
        var mockMeasurementFormatter: MeasurementFormatterProtocolMock!

        var sut: SettingsCellViewModelBuilder!

        beforeEach {
            mockStore = MockAppStore()
            mockMeasurementFormatter = MeasurementFormatterProtocolMock()

            sut = SettingsCellViewModelBuilder(store: mockStore,
                                               measurementFormatter: mockMeasurementFormatter)
        }

        describe("buildDistanceCellModels()") {

            var results: [SettingsCellViewModel]!

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
                for (caseIdx, currentDistance) in searchDistances.enumerated() {
                    context("when the current search distance is .\(currentDistance)") {

                        beforeEach {
                            results = sut.buildDistanceCellModels(currentDistance)
                        }

                        it("has exactly one cell model per sorting option") {
                            expect(results.count) == searchDistances.count
                        }

                        it("has the title in each cell model as returned by mockMeasurementFormatter") {
                            for (idx, resultCellModel) in results.enumerated() {
                                let expectedMeasurement = searchDistances[idx].distanceType.measurement
                                expect(resultCellModel.title) ==
                                    "stub_\(expectedMeasurement.value)_\(expectedMeasurement.unit.symbol)"
                            }
                        }

                        it("has true as the value of isSelected for the current case") {
                            expect(results[caseIdx].isSelected) == true
                        }

                        it("has false as the value of isSelected for the other cases") {
                            for (idx, resultCellModel) in results.enumerated() where idx != caseIdx {
                                expect(resultCellModel.isSelected) == false
                            }
                        }

                        it("dispatches the correct .setSorting action when dispatchAction() is called") {
                            expect(mockStore.dispatchedActions.isEmpty) == true
                            results[caseIdx].dispatchAction()
                            expect(mockStore.dispatchedActions.first as? SearchPreferencesAction) == .setDistance(currentDistance)
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

        describe("buildSortingCellModels()") {

            let stubCopyContent = SettingsSortPreferenceCopyContent.stubValue()

            var results: [SettingsCellViewModel]!

            for (caseIdx, currentSortingCase) in PlaceLookupSorting.allCases.enumerated() {

                context("when the current PlaceLookupSorting case is .\(currentSortingCase)") {

                    beforeEach {
                        results = sut.buildSortingCellModels(currentSortingCase,
                                                             copyContent: stubCopyContent)
                    }

                    it("has exactly one cell model per sorting option") {
                        expect(results.count) == PlaceLookupSorting.allCases.count
                    }

                    it("has the correct title in each cell model as found in stubCopyContent") {
                        for (idx, resultCellModel) in results.enumerated() {
                            expect(resultCellModel.title) == stubCopyContent.title(PlaceLookupSorting.allCases[idx])
                        }
                    }

                    it("has true as the value of isSelected for the current case") {
                        expect(results[caseIdx].isSelected) == true
                    }

                    it("has false as the value of isSelected for the other cases") {
                        for (idx, resultCellModel) in results.enumerated() where idx != caseIdx {
                            expect(resultCellModel.isSelected) == false
                        }
                    }

                    it("dispatches the correct .setSorting action when dispatchAction() is called") {
                        expect(mockStore.dispatchedActions.isEmpty) == true
                        results[caseIdx].dispatchAction()
                        expect(mockStore.dispatchedActions.first as? SearchPreferencesAction) == .setSorting(currentSortingCase)
                    }

                }

            }

        }

    }

}
