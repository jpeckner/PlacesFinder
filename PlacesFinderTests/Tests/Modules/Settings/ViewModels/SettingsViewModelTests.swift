//
//  SettingsViewModelTests.swift
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
import SwiftDux
import SwiftDuxTestComponents

class SettingsViewModelTests: QuickSpec {

    // swiftlint:disable force_unwrapping
    // swiftlint:disable implicitly_unwrapped_optional
    override func spec() {

        var mockActionSubscriber: MockSubscriber<SearchPreferencesAction>!
        var sut: SettingsViewModel!

        func buildSectionViewModels() -> NonEmptyArray<SettingsSectionViewModel> {
            let sections = [0, 1, 2].map { sectionIdx in
                SettingsSectionViewModel.stubValue(
                    id: .searchDistance,
                    headerType: .plain(.stubValue(title: "stubSection\(sectionIdx)Title")),
                    cells: [0, 1, 2].map { cellIdx in
                        SettingsCellViewModel(title: "stubSection\(sectionIdx)Cell\(cellIdx)",
                                              isSelected: cellIdx == 1,
                                              colorings: AppColorings.defaultColorings.settings.cellColorings,
                                              actionSubscriber: AnySubscriber(mockActionSubscriber),
                                              action: .showAboutApp(AboutAppLinkPayload()))
                    }
                )
            }

            return NonEmptyArray(sections)!
        }

        beforeEach {
            mockActionSubscriber = MockSubscriber()

            let sections = buildSectionViewModels()
            sut = SettingsViewModel(sections: sections,
                                    colorings: AppColorings.defaultColorings.settings)
        }

        describe("tableModel") {

            it("returns a viewmodel with the expected number of sections") {
                expect(sut.sections.value.count) == 3
            }

            it("returns a viewmodel with the expected contents in each section") {
                for (sectionIdx, section) in sut.sections.value.enumerated() {
                    for cellIdx in [0, 1, 2] {
                        let cellModel = section.cells[cellIdx]
                        expect(cellModel.title) == "stubSection\(sectionIdx)Cell\(cellIdx)"
                    }
                }
            }

        }

    }

}
