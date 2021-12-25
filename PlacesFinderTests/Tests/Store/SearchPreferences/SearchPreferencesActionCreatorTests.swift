//
//  SearchPreferencesActionCreatorTests.swift
//  PlacesFinderTests
//
//  Copyright (c) 2019 Justin Peckner
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
import SwiftDux

class SearchPreferencesActionCreatorTests: QuickSpec {

    // swiftlint:disable implicitly_unwrapped_optional
    override func spec() {

        describe("setMeasurementSystem()") {

            var result: Action!

            context("when the arg is .imperial") {
                beforeEach {
                    result = SearchPreferencesActionCreator.setMeasurementSystem(.imperial)
                }

                it("returns SearchPreferencesAction.setDistance, with a distance of ten miles") {
                    expect(result as? SearchPreferencesAction) == .setDistance(.imperial(.tenMiles))
                }
            }

            context("when the arg is .metric") {
                beforeEach {
                    result = SearchPreferencesActionCreator.setMeasurementSystem(.metric)
                }

                it("returns SearchPreferencesAction.setDistance, with a distance of twenty kilometers") {
                    expect(result as? SearchPreferencesAction) == .setDistance(.metric(.twentyKilometers))
                }
            }

        }

    }

}
