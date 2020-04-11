//
//  SearchInstructionsViewModelBuilderTests.swift
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

class SearchInstructionsViewModelBuilderTests: QuickSpec {

    // swiftlint:disable implicitly_unwrapped_optional
    override func spec() {

        var sut: SearchInstructionsViewModelBuilder!
        var result: SearchInstructionsViewModel!

        beforeEach {
            sut = SearchInstructionsViewModelBuilder()
        }

        describe("buildViewModel()") {

            beforeEach {
                result = sut.buildViewModel(copyContent: SearchInstructionsCopyContent.stubValue())
            }

            it("returns its expected value") {
                expect(result) == SearchInstructionsViewModel(
                    infoViewModel: StaticInfoViewModel(imageName: "stubIconImageName",
                                                       title: "stubTitle",
                                                       description: "stubDescription"),
                    resultsSource: "stubResultsSource"
                )
            }

        }

    }

}
