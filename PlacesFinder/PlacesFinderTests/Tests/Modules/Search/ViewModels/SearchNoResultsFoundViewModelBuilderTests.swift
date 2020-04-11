//
//  SearchNoResultsFoundViewModelBuilderTests.swift
//  PlacesFinder
//
//  Created by Justin Peckner.
//  Copyright © 2020 Justin Peckner. All rights reserved.
//

import Nimble
import Quick
import Shared
import SwiftDux

// swiftlint:disable type_name
class SearchNoResultsFoundViewModelBuilderTests: QuickSpec {

    // swiftlint:disable implicitly_unwrapped_optional
    override func spec() {

        let stubCopyContent = SearchNoResultsCopyContent.stubValue()

        var sut: SearchNoResultsFoundViewModelBuilder!
        var result: SearchNoResultsFoundViewModel!

        beforeEach {
            sut = SearchNoResultsFoundViewModelBuilder()
        }

        describe("buildViewModel()") {

            beforeEach {
                result = sut.buildViewModel(stubCopyContent)
            }

            it("returns the expected infoViewModel") {
                expect(result.messageViewModel) == SearchMessageViewModel(copyContent: stubCopyContent)
            }

        }

    }

}
