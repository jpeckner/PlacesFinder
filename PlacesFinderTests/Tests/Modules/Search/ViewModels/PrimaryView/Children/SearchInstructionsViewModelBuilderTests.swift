//
//  SearchInstructionsViewModelBuilderTests.swift
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

// swiftlint:disable blanket_disable_command
// swiftlint:disable implicitly_unwrapped_optional
class SearchInstructionsViewModelBuilderTests: QuickSpec {

    override func spec() {

        var sut: SearchInstructionsViewModelBuilder!
        var result: SearchInstructionsViewModel!

        beforeEach {
            sut = SearchInstructionsViewModelBuilder()
        }

        describe("buildViewModel()") {

            beforeEach {
                result = sut.buildViewModel(
                    copyContent: SearchInstructionsCopyContent.stubValue(),
                    colorings: AppColorings.defaultColorings.standard
                )
            }

            it("returns its expected value") {
                expect(result) == SearchInstructionsViewModel(
                    infoViewModel: StaticInfoViewModel(
                        imageName: "stubIconImageName",
                        title: "stubTitle",
                        description: "stubDescription",
                        colorings: AppColorings.defaultColorings.standard
                    ),
                    resultsSource: "stubResultsSource"
                )
            }

        }

    }

}
// swiftlint:enable blanket_disable_command
