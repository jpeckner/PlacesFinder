//
//  SettingsViewPropsBuilderTests.swift
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

import Nimble
import Quick
import Shared
import SharedTestComponents
import SwiftDux

// swiftlint:disable blanket_disable_command
// swiftlint:disable function_body_length
// swiftlint:disable implicitly_unwrapped_optional
class SettingsViewPropsBuilderTests: AsyncSpec {

    override class func spec() {

        let stubUnitsHeaderProps = SettingsUnitsHeaderProps.stubValue()
        let stubPlainHeaderProps = SettingsPlainHeaderProps.stubValue()

        var mockMeasurementSystemHeaderPropsBuilder: SettingsUnitsHeaderPropsBuilderProtocolMock!
        var mockPlainHeaderPropsBuilder: SettingsPlainHeaderPropsBuilderProtocolMock!
        var stubDistanceCellProps: [SettingsCellProps]!
        var stubSortingCellProps: [SettingsCellProps]!
        var mockSettingsCellPropsBuilder: SettingsCellPropsBuilderProtocolMock!

        var sut: SettingsViewPropsBuilder!
        var result: SettingsViewProps!

        beforeEach {
            mockMeasurementSystemHeaderPropsBuilder = SettingsUnitsHeaderPropsBuilderProtocolMock()
            mockMeasurementSystemHeaderPropsBuilder
                .buildPropsTitleCurrentlyActiveSystemColoringsReturnValue = stubUnitsHeaderProps

            mockPlainHeaderPropsBuilder = SettingsPlainHeaderPropsBuilderProtocolMock()
            mockPlainHeaderPropsBuilder.buildPropsTitleColoringsReturnValue = stubPlainHeaderProps

            stubDistanceCellProps = [
                SettingsCellProps(title: "stubDistanceCellProps",
                                  isSelected: false,
                                  colorings: AppColorings.defaultColorings.settings.cellColorings,
                                  action: .showAboutApp(AboutAppLinkPayload()))
            ]
            stubSortingCellProps = [
                SettingsCellProps(title: "stubSortingCellProps",
                                  isSelected: false,
                                  colorings: AppColorings.defaultColorings.settings.cellColorings,
                                  action: .showAboutApp(AboutAppLinkPayload()))
            ]
            mockSettingsCellPropsBuilder = SettingsCellPropsBuilderProtocolMock()
            mockSettingsCellPropsBuilder.buildDistanceCellPropsCurrentDistanceTypeColoringsReturnValue =
                stubDistanceCellProps
            mockSettingsCellPropsBuilder.buildSortingCellPropsCurrentSortingColoringsReturnValue =
                stubSortingCellProps

            sut = SettingsViewPropsBuilder(
                measurementSystemHeaderPropsBuilder: mockMeasurementSystemHeaderPropsBuilder,
                plainHeaderPropsBuilder: mockPlainHeaderPropsBuilder,
                settingsCellPropsBuilder: mockSettingsCellPropsBuilder
            )
        }

        describe("buildProps()") {

            let stubSearchPreferencesState = SearchPreferencesState(
                stored: StoredSearchPreferences(
                    distance: .imperial(.twentyMiles),
                    sorting: .reviewCount
                )
            )

            beforeEach {
                result = sut.buildProps(searchPreferencesState: stubSearchPreferencesState,
                                        appDisplayName: AppBundleInfo.stubValue().displayName,
                                        colorings: AppColorings.defaultColorings.settings)
            }

            it("returns props with a .measurementSystem header in index 0") {
                let section = result.sections.value[0]
                expect(section.headerType) == .measurementSystem(stubUnitsHeaderProps)
            }

            it("returns props with the cell props returned by mockSettingsCellPropsBuilder in index 0") {
                let section = result.sections.value[0]
                expect(section.cells) == stubDistanceCellProps
            }

            it("returns props with a .plain header in index 1") {
                let section = result.sections.value[1]
                expect(section.headerType) == .plain(stubPlainHeaderProps)
            }

            it("returns props with the cell props returned by mockSettingsCellPropsBuilder in index 1") {
                let section = result.sections.value[1]
                expect(section.cells) == stubSortingCellProps
            }

            it("returns props with an about-app cell in index 2 that shows the about-app view") {
                let section = result.sections.value[2]
                expect(section.headerType) == nil
                expect(section.cells.count) == 1
                expect(section.cells.first?.action.value) == .showAboutApp(AboutAppLinkPayload())
            }

        }

    }

}
// swiftlint:enable blanket_disable_command
