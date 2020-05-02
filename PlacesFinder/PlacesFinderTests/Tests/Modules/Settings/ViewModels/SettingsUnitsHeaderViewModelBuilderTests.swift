//
//  SettingsUnitsHeaderViewModelBuilderTests.swift
//  PlacesFinderTests
//
//  Created by Justin Peckner.
//  Copyright © 2020 Justin Peckner. All rights reserved.
//

import Nimble
import Quick
import Shared
import SharedTestComponents
import SwiftDux
import SwiftDuxTestComponents

class SettingsUnitsHeaderViewModelBuilderTests: QuickSpec {

    // swiftlint:disable implicitly_unwrapped_optional
    override func spec() {

        var mockStore: MockAppStore!

        var sut: SettingsUnitsHeaderViewModelBuilder!
        var result: SettingsUnitsHeaderViewModel!

        beforeEach {
            mockStore = MockAppStore()

            sut = SettingsUnitsHeaderViewModelBuilder(store: mockStore)
        }

        describe("buildViewModel()") {

            beforeEach {
                result = sut.buildViewModel("stubTitle",
                                            currentlyActiveSystem: .imperial,
                                            copyContent: SettingsMeasurementSystemCopyContent.stubValue())
            }

            it("returns a viewmodel with the expected title...") {
                expect(result.title) == "stubTitle"
            }

            it("...and with the current active system as a non-selectable option...") {
                var numNonSelectableOptions = 0
                for option in result.systemOptions {
                    if case let .nonSelectable(title) = option {
                        numNonSelectableOptions += 1
                        expect(title) == "stubImperialTitle"
                    }

                }

                expect(numNonSelectableOptions) == 1
            }

            it("...and with the non-currently active systems as selectable options...") {
                var numSelectableOptions = 0
                for option in result.systemOptions {
                    if case let .selectable(title, actionBlock) = option {
                        numSelectableOptions += 1
                        expect(title) == "stubMetricTitle"

                        expect(mockStore.dispatchedActions.isEmpty) == true
                        actionBlock.value()
                        expect(mockStore.dispatchedActions.first as? SearchPreferencesAction)
                            == .setDistance(.metric(.defaultDistance))
                    }
                }

                expect(numSelectableOptions) == MeasurementSystem.allCases.count - 1
            }

        }

    }

}
