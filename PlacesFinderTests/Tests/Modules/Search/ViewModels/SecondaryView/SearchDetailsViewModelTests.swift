//
//  SearchDetailsViewModelTests.swift
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

// swiftlint:disable blanket_disable_command
// swiftlint:disable implicitly_unwrapped_optional
class SearchDetailsViewModelTests: QuickSpec {

    private enum StubViewModelAction: Action {
        case removeDetailedEntityAction
    }

    override func spec() {

        let stubInfoCellModels: [SearchDetailsInfoSectionViewModel] = [
            .basicInfo(.stubValue(name: .stubValue("cellIdx0"))),
            .basicInfo(.stubValue(name: .stubValue("cellIdx1"))),
            .basicInfo(.stubValue(name: .stubValue("cellIdx2"))),
        ]
        let stubInfoSection = SearchDetailsViewModel.Section.info(stubInfoCellModels)
        let stubLocationSection = SearchDetailsViewModel.Section.location([.mapCoordinate(.stubValue())])

        var mockActionSubscriber: MockSubscriber<Search.Action>!
        var sut: SearchDetailsViewModel!

        beforeEach {
            mockActionSubscriber = MockSubscriber()

            sut = SearchDetailsViewModel(placeName: "stubPlaceName",
                                         sections: [stubInfoSection, stubLocationSection],
                                         actionSubscriber: AnySubscriber(mockActionSubscriber),
                                         removeDetailedEntityAction: .searchActivity(.removeDetailedEntity))
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
// swiftlint:enable blanket_disable_command
