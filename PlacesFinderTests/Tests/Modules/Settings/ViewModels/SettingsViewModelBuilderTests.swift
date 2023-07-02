//
//  SettingsViewModelBuilderTests.swift
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

class SettingsViewModelBuilderTests: QuickSpec {

    // swiftlint:disable function_body_length
    // swiftlint:disable identifier_name
    // swiftlint:disable implicitly_unwrapped_optional
    override func spec() {

        let stubUnitsHeaderViewModel = SettingsUnitsHeaderViewModel.stubValue()
        let stubPlainHeaderViewModel = SettingsPlainHeaderViewModel.stubValue()

        var mockActionSubscriber: MockSubscriber<SearchPreferencesAction>!
        var mockMeasurementSystemHeaderViewModelBuilder: SettingsUnitsHeaderViewModelBuilderProtocolMock!
        var mockPlainHeaderViewModelBuilder: SettingsPlainHeaderViewModelBuilderProtocolMock!
        var stubDistanceCellModels: [SettingsCellViewModel]!
        var stubSortingCellModels: [SettingsCellViewModel]!
        var mockSettingsCellViewModelBuilder: SettingsCellViewModelBuilderProtocolMock!

        var sut: SettingsViewModelBuilder!
        var result: SettingsViewModel!

        beforeEach {
            mockActionSubscriber = MockSubscriber()

            mockMeasurementSystemHeaderViewModelBuilder = SettingsUnitsHeaderViewModelBuilderProtocolMock()
            mockMeasurementSystemHeaderViewModelBuilder
                .buildViewModelTitleCurrentlyActiveSystemCopyContentColoringsReturnValue = stubUnitsHeaderViewModel

            mockPlainHeaderViewModelBuilder = SettingsPlainHeaderViewModelBuilderProtocolMock()
            mockPlainHeaderViewModelBuilder.buildViewModelTitleColoringsReturnValue = stubPlainHeaderViewModel

            stubDistanceCellModels = [
                SettingsCellViewModel(title: "stubDistanceCellModel",
                                      isSelected: false,
                                      colorings: AppColorings.defaultColorings.settings.cellColorings,
                                      actionSubscriber: AnySubscriber(mockActionSubscriber),
                                      action: .showAboutApp(AboutAppLinkPayload()))
            ]
            stubSortingCellModels = [
                SettingsCellViewModel(title: "stubSortingCellModel",
                                      isSelected: false,
                                      colorings: AppColorings.defaultColorings.settings.cellColorings,
                                      actionSubscriber: AnySubscriber(mockActionSubscriber),
                                      action: .showAboutApp(AboutAppLinkPayload()))
            ]
            mockSettingsCellViewModelBuilder = SettingsCellViewModelBuilderProtocolMock()
            mockSettingsCellViewModelBuilder.buildDistanceCellModelsCurrentDistanceTypeColoringsReturnValue =
                stubDistanceCellModels
            mockSettingsCellViewModelBuilder.buildSortingCellModelsCurrentSortingCopyContentColoringsReturnValue =
                stubSortingCellModels

            sut = SettingsViewModelBuilder(
                actionSubscriber: AnySubscriber(mockActionSubscriber),
                measurementSystemHeaderViewModelBuilder: mockMeasurementSystemHeaderViewModelBuilder,
                plainHeaderViewModelBuilder: mockPlainHeaderViewModelBuilder,
                settingsCellViewModelBuilder: mockSettingsCellViewModelBuilder
            )
        }

        describe("buildViewModel()") {

            let stubSearchPreferencesState = SearchPreferencesState(
                stored: StoredSearchPreferences(
                    distance: .imperial(.twentyMiles),
                    sorting: .reviewCount
                )
            )
            let stubAppCopyContent = AppCopyContent.stubValue()

            beforeEach {
                result = sut.buildViewModel(searchPreferencesState: stubSearchPreferencesState,
                                            appCopyContent: stubAppCopyContent,
                                            appDisplayName: AppBundleInfo.stubValue().displayName,
                                            colorings: AppColorings.defaultColorings.settings)
            }

            it("returns a view model with a .measurementSystem header in index 0") {
                let section = result.sections.value[0]
                expect(section.headerType) == .measurementSystem(stubUnitsHeaderViewModel)
            }

            it("returns a view model with the cellmodels returned by mockSettingsCellViewModelBuilder in index 0") {
                let section = result.sections.value[0]
                expect(section.cells) == stubDistanceCellModels
            }

            it("returns a view model with a .plain header in index 1") {
                let section = result.sections.value[1]
                expect(section.headerType) == .plain(stubPlainHeaderViewModel)
            }

            it("returns a view model with the cellmodels returned by mockSettingsCellViewModelBuilder in index 1") {
                let section = result.sections.value[1]
                expect(section.cells) == stubSortingCellModels
            }

        }

    }

}
