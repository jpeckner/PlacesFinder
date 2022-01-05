//
//  SettingsUnitsHeaderViewModelBuilderTests.swift
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