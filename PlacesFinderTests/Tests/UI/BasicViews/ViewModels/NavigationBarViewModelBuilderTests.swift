//
//  NavigationBarViewModelBuilderTests.swift
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
class NavigationBarViewModelBuilderTests: QuickSpec {

    override func spec() {

        var sut: NavigationBarViewModelBuilder!
        var result: NavigationBarTitleViewModel!

        beforeEach {
            sut = NavigationBarViewModelBuilder()
        }

        describe("buildTitleViewModel()") {

            beforeEach {
                result = sut.buildTitleViewModel(copyContent: DisplayNameCopyContent.stubValue())
            }

            it("returns its expected value") {
                expect(result) == NavigationBarTitleViewModel(displayName: "stubDisplayName")
            }

        }

    }

}
// swiftlint:enable blanket_disable_command
