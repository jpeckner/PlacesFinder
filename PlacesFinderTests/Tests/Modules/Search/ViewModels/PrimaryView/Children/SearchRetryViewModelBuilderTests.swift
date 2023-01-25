//
//  SearchRetryViewModelBuilderTests.swift
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
