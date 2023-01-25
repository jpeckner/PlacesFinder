//
//  SettingsCellViewModelBuilderTests.swift
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

import Combine
import Nimble
import Quick
import Shared
import SharedTestComponents
import SwiftDux
import SwiftDuxTestComponents

class SettingsCellViewModelBuilderTests: QuickSpec {

    // swiftlint:disable function_body_length
    // swiftlint:disable implicitly_unwrapped_optional
    override func spec() {

        var mockActionSubscriber: MockSubscriber<SearchPreferencesAction>!
        var mockMeasurementFormatter: MeasurementFormatterProtocolMock!

        var sut: SettingsCellViewModelBuilder!

        beforeEach {
            mockActionSubscriber = MockSubscriber()
            mockMeasurementFormatter = MeasurementFormatterProtocolMock()

            sut = SettingsCellViewModelBuilder(actionSubscriber: AnySubscriber(mockActionSubscriber),
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
                for (caseIdx, currentDistanceType) in searchDistances.enumerated() {
                    context("when the current search distance is .\(currentDistanceType)") {

                        beforeEach {
                            results = sut.buildDistanceCellModels(currentDistanceType: currentDistanceType)
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
                            expect(mockActionSubscriber.receivedInputs.isEmpty) == true
                            results[caseIdx].dispatchAction()
                            expect(mockActionSubscriber.receivedInputs.first) == .setDistance(currentDistanceType)
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

            for (caseIdx, currentSorting) in PlaceLookupSorting.allCases.enumerated() {

                context("when the current PlaceLookupSorting case is .\(currentSorting)") {

                    beforeEach {
                        results = sut.buildSortingCellModels(currentSorting: currentSorting,
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
                        expect(mockActionSubscriber.receivedInputs.isEmpty) == true
                        results[caseIdx].dispatchAction()
                        expect(mockActionSubscriber.receivedInputs.first) == .setSorting(currentSorting)
                    }

                }

            }

        }

    }

}
