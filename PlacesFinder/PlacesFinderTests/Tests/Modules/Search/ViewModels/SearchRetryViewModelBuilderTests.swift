//
//  SearchRetryViewModelBuilderTests.swift
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
import SwiftDux

class SearchRetryViewModelBuilderTests: QuickSpec {

    private enum StubViewModelAction: Action {
        case detailEntity
    }

    // swiftlint:disable implicitly_unwrapped_optional
    override func spec() {

        let stubCopyContent = SearchRetryCopyContent.stubValue()

        var sut: SearchRetryViewModelBuilder!
        var result: SearchRetryViewModel!

        beforeEach {
            sut = SearchRetryViewModelBuilder()
        }

        describe("buildViewModel()") {
            var hasTriggeredCTABlock: Bool!

            beforeEach {
                hasTriggeredCTABlock = false
                result = sut.buildViewModel(stubCopyContent) {
                    hasTriggeredCTABlock = true
                }
            }

            it("returns the expected infoViewModel") {
                expect(result.ctaViewModel.infoViewModel) == stubCopyContent.staticInfoViewModel
            }

            it("returns the expected ctaTitle") {
                expect(result.ctaViewModel.ctaTitle) == stubCopyContent.ctaTitle
            }

            it("includes the block passed to it") {
                expect(hasTriggeredCTABlock) == false
                result.ctaViewModel.ctaBlock?.value()
                expect(hasTriggeredCTABlock) == true
            }

        }

    }

}
