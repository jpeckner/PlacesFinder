//
//  SettingsViewModelTests.swift
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

class SettingsViewModelTests: QuickSpec {

    // swiftlint:disable force_unwrapping
    // swiftlint:disable implicitly_unwrapped_optional
    override func spec() {

        var mockStore: MockAppStore!
        var sut: SettingsViewModel!

        func buildSectionViewModels() -> NonEmptyArray<SettingsSectionViewModel> {
            let sections = [0, 1, 2].map { sectionIdx in
                SettingsSectionViewModel.stubValue(
                    headerType: .plain(.stubValue(title: "stubSection\(sectionIdx)Title")),
                    cells: [0, 1, 2].map { cellIdx in
                        SettingsCellViewModel(title: "stubSection\(sectionIdx)Cell\(cellIdx)",
                                              isSelected: cellIdx == 1,
                                              store: mockStore,
                                              action: StubAction.genericAction)
                    }
                )
            }

            return NonEmptyArray(sections)!
        }

        beforeEach {
            mockStore = MockAppStore()

            let sections = buildSectionViewModels()
            sut = SettingsViewModel(sections: sections)
        }

        describe("tableModel") {

            it("returns a viewmodel with the expected number of sections") {
                expect(sut.tableModel.sectionModels.count) == 3
            }

            it("returns a viewmodel with the expected contents in each section") {
                for (sectionIdx, section) in sut.tableModel.sectionModels.enumerated() {
                    expect(section.title) == "stubSection\(sectionIdx)Title"

                    for cellIdx in [0, 1, 2] {
                        let groupedCellModel = section.cellModels[cellIdx]
                        guard case let .basic(basicCellModel) = groupedCellModel else {
                            fail("Unexpected value found: \(groupedCellModel)")
                            return
                        }

                        expect(basicCellModel.title) == "stubSection\(sectionIdx)Cell\(cellIdx)"
                    }
                }
            }

        }

    }

}
