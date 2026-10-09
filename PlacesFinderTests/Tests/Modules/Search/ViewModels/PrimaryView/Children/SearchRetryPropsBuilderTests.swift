//
//  SearchRetryPropsBuilderTests.swift
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
// swiftlint:disable implicitly_unwrapped_optional
class SearchRetryPropsBuilderTests: AsyncSpec {

    override class func spec() {

        var sut: SearchRetryPropsBuilder!
        var result: SearchRetryProps!

        beforeEach {
            sut = SearchRetryPropsBuilder()
        }

        describe("buildProps()") {
            let stubRetryAction = Search.Action.searchActivity(.initialPageRequested(.stubValue()))

            beforeEach {
                result = sut.buildProps(colorings: AppColorings.defaultColorings.searchCTA,
                                        retryAction: stubRetryAction)
            }

            it("returns the expected props") {
                expect(result.ctaViewProps.props) == StaticInfoViewProps(
                    image: Asset.error,
                    title: L10n.SearchRetry.title,
                    description: L10n.SearchRetry.description,
                    colorings: AppColorings.defaultColorings.searchCTA
                )
            }

            it("returns the expected ctaTitle") {
                expect(result.ctaViewProps.ctaTitle) == L10n.SearchRetry.ctaTitle
            }

            it("includes the retry action passed to it") {
                expect(result.retryAction.value) == stubRetryAction
            }

        }

    }

}
// swiftlint:enable blanket_disable_command
