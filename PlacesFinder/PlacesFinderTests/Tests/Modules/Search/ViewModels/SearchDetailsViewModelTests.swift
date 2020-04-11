//
//  SearchDetailsViewModelTests.swift
//  PlacesFinder
//
//  Created by Justin Peckner.
//  Copyright © 2020 Justin Peckner. All rights reserved.
//

import Nimble
import Quick
import Shared
import SwiftDux

class SearchDetailsViewModelTests: QuickSpec {

    private enum StubViewModelAction: Action {
        case removeDetailedEntityAction
    }

    // swiftlint:disable implicitly_unwrapped_optional
    override func spec() {

        let stubInfoCellModels: [SearchDetailsInfoSectionViewModel] = [
            .basicInfo(.stubValue(name: .stubValue("cellIdx0"))),
            .basicInfo(.stubValue(name: .stubValue("cellIdx1"))),
            .basicInfo(.stubValue(name: .stubValue("cellIdx2"))),
        ]
        let stubInfoSection = SearchDetailsViewModel.Section.info(stubInfoCellModels)
        let stubLocationSection = SearchDetailsViewModel.Section.location([.mapCoordinate(.stubValue())])

        var mockStore: MockAppStore!
        var sut: SearchDetailsViewModel!

        beforeEach {
            mockStore = MockAppStore()

            sut = SearchDetailsViewModel(placeName: "stubPlaceName",
                                         sections: [stubInfoSection, stubLocationSection],
                                         store: mockStore,
                                         removeDetailedEntityAction: StubViewModelAction.removeDetailedEntityAction)
        }

        describe("sectionsCount") {

            it("returns the number of sections") {
                expect(sut.sectionsCount) == 2
            }

        }

        describe("section(:)") {

            it("returns the section at the given index") {
                let returnedSection = sut.section(sectionIndex: 1)
                expect(returnedSection) == stubLocationSection
            }

        }

        describe("cellViewModels(:)") {

            it("returns the viewmodels at the given index") {
                let returnedCellModels = sut.cellViewModels(sectionIndex: 0)
                expect(returnedCellModels as? [SearchDetailsInfoSectionViewModel]) == stubInfoCellModels
            }

        }

        describe("cellViewModel(:)") {

            it("returns the viewmodel at the given section and row indices") {
                let returnedCellModels = sut.cellViewModel(sectionIndex: 0, rowIndex: 2)
                expect(returnedCellModels as? SearchDetailsInfoSectionViewModel) == stubInfoCellModels[2]
            }

        }

    }

}
