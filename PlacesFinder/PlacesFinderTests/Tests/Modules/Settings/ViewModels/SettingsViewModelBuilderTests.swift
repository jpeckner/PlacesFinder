//
//  SettingsViewModelBuilderTests.swift
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

class SettingsViewModelBuilderTests: QuickSpec {

    // swiftlint:disable function_body_length
    // swiftlint:disable identifier_name
    // swiftlint:disable implicitly_unwrapped_optional
    override func spec() {

        let stubUnitsHeaderViewModel = SettingsUnitsHeaderViewModel.stubValue()
        let stubPlainHeaderViewModel = SettingsPlainHeaderViewModel.stubValue()

        var mockStore: MockAppStore!
        var mockMeasurementSystemHeaderViewModelBuilder: SettingsUnitsHeaderViewModelBuilderProtocolMock!
        var mockPlainHeaderViewModelBuilder: SettingsPlainHeaderViewModelBuilderProtocolMock!
        var stubDistanceCellModels: [SettingsCellViewModel]!
        var stubSortingCellModels: [SettingsCellViewModel]!
        var mockSettingsCellViewModelBuilder: SettingsCellViewModelBuilderProtocolMock!

        var sut: SettingsViewModelBuilder!
        var result: SettingsViewModel!

        beforeEach {
            mockStore = MockAppStore()

            mockMeasurementSystemHeaderViewModelBuilder = SettingsUnitsHeaderViewModelBuilderProtocolMock()
            mockMeasurementSystemHeaderViewModelBuilder.buildViewModelTitleCurrentlyActiveSystemCopyContentReturnValue =
                stubUnitsHeaderViewModel

            mockPlainHeaderViewModelBuilder = SettingsPlainHeaderViewModelBuilderProtocolMock()
            mockPlainHeaderViewModelBuilder.buildViewModelReturnValue = stubPlainHeaderViewModel

            stubDistanceCellModels = [
                SettingsCellViewModel(title: "stubDistanceCellModel",
                                      isSelected: false,
                                      store: mockStore,
                                      action: StubAction.genericAction)
            ]
            stubSortingCellModels = [
                SettingsCellViewModel(title: "stubSortingCellModel",
                                      isSelected: false,
                                      store: mockStore,
                                      action: StubAction.genericAction)
            ]
            mockSettingsCellViewModelBuilder = SettingsCellViewModelBuilderProtocolMock()
            mockSettingsCellViewModelBuilder.buildDistanceCellModelsReturnValue = stubDistanceCellModels
            mockSettingsCellViewModelBuilder.buildSortingCellModelsCopyContentReturnValue = stubSortingCellModels

            sut = SettingsViewModelBuilder(
                store: mockStore,
                measurementSystemHeaderViewModelBuilder: mockMeasurementSystemHeaderViewModelBuilder,
                plainHeaderViewModelBuilder: mockPlainHeaderViewModelBuilder,
                settingsCellViewModelBuilder: mockSettingsCellViewModelBuilder
            )
        }

        describe("buildViewModel()") {

            let stubSearchPreferencesState = SearchPreferencesState(distance: .imperial(.twentyMiles),
                                                                    sorting: .reviewCount)
            let stubAppCopyContent = AppCopyContent(displayName: .stubValue("stubDisplayName"))

            beforeEach {
                result = sut.buildViewModel(searchPreferencesState: stubSearchPreferencesState,
                                            appCopyContent: stubAppCopyContent)
            }

            it("returns a view model with a .measurementSystem header in index 0") {
                let section = result.sections.value[0]

                guard case let .measurementSystem(headerViewModel) = section.headerType else {
                    fail("Unexpected value found: \(section.headerType)")
                    return
                }

                expect(headerViewModel) == stubUnitsHeaderViewModel
            }

            it("returns a view model with the cellmodels returned by mockSettingsCellViewModelBuilder in index 0") {
                let section = result.sections.value[0]
                expect(section.cells) == stubDistanceCellModels
            }

            it("returns a view model with a .plain header in index 1") {
                let section = result.sections.value[1]

                guard case let .plain(headerViewModel) = section.headerType else {
                    fail("Unexpected value found: \(section.headerType)")
                    return
                }

                expect(headerViewModel) == stubPlainHeaderViewModel
            }

            it("returns a view model with the cellmodels returned by mockSettingsCellViewModelBuilder in index 1") {
                let section = result.sections.value[1]
                expect(section.cells) == stubSortingCellModels
            }

        }

    }

}
