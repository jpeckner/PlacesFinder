//
//  SettingsViewPropsTests.swift
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
import SwiftDux

// swiftlint:disable blanket_disable_command
// swiftlint:disable force_unwrapping
// swiftlint:disable implicitly_unwrapped_optional
class SettingsViewPropsTests: AsyncSpec {

    override class func spec() {

        var sut: SettingsViewProps!

        func buildSectionProps() -> NonEmptyArray<SettingsSectionProps> {
            let sections = [0, 1, 2].map { sectionIdx in
                SettingsSectionProps.stubValue(
                    id: .searchDistance,
                    headerType: .plain(.stubValue(title: "stubSection\(sectionIdx)Title")),
                    cells: [0, 1, 2].map { cellIdx in
                        SettingsCellProps(title: "stubSection\(sectionIdx)Cell\(cellIdx)",
                                          isSelected: cellIdx == 1,
                                          colorings: AppColorings.defaultColorings.settings.cellColorings,
                                          action: .showAboutApp(AboutAppLinkPayload()))
                    }
                )
            }

            return NonEmptyArray(sections)!
        }

        beforeEach {
            let sections = buildSectionProps()
            sut = SettingsViewProps(sections: sections,
                                    colorings: AppColorings.defaultColorings.settings)
        }

        describe("tableModel") {

            it("returns props with the expected number of sections") {
                expect(sut.sections.value.count) == 3
            }

            it("returns props with the expected contents in each section") {
                for (sectionIdx, section) in sut.sections.value.enumerated() {
                    for cellIdx in [0, 1, 2] {
                        let cellProps = section.cells[cellIdx]
                        expect(cellProps.title) == "stubSection\(sectionIdx)Cell\(cellIdx)"
                    }
                }
            }

        }

    }

}
// swiftlint:enable blanket_disable_command
