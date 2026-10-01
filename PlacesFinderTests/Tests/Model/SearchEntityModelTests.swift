//
//  SearchEntityModelTests.swift
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

import Foundation
import Nimble
import Quick
import Shared
import SharedTestComponents

// swiftlint:disable blanket_disable_command
class SearchEntityModelTests: QuickSpec {

    override func spec() {

        describe("init(isPermanentlyClosed:)") {

            let stubRatings = SearchRatings.stubValue(average: .five, numRatings: 123)

            func buildModel(ratings: SearchRatings? = stubRatings,
                            image: URL? = .stubValue(),
                            isPermanentlyClosed: Bool? = false) -> SearchEntityModel? {
                return SearchEntityModel(id: .stubValue("stubID"),
                                         name: .stubValue("stubEntityName"),
                                         url: .stubValue(),
                                         ratings: ratings,
                                         image: image,
                                         addressLines: .stubValue(),
                                         displayPhone: .stubValue("stubDisplayPhone"),
                                         dialablePhone: .stubValue("stubDialablePhone"),
                                         pricing: .stubValue(),
                                         coordinate: .stubValue(),
                                         isPermanentlyClosed: isPermanentlyClosed)
            }

            let expectedModel = SearchEntityModel(id: .stubValue("stubID"),
                                                  name: .stubValue("stubEntityName"),
                                                  url: .stubValue(),
                                                  ratings: stubRatings,
                                                  image: .stubValue(),
                                                  addressLines: .stubValue(),
                                                  displayPhone: .stubValue("stubDisplayPhone"),
                                                  dialablePhone: .stubValue("stubDialablePhone"),
                                                  pricing: .stubValue(),
                                                  coordinate: .stubValue())

            context("when the isPermanentlyClosed arg is true") {
                it("returns nil") {
                    expect(buildModel(isPermanentlyClosed: true)) == nil
                }
            }

            context("else when the ratings arg is nil") {
                it("returns nil") {
                    expect(buildModel(ratings: nil)) == nil
                }
            }

            context("else when the image arg is nil") {
                it("returns nil") {
                    expect(buildModel(image: nil)) == nil
                }
            }

            context("else when the isPermanentlyClosed arg is nil") {
                it("returns a SearchEntityModel with the args' values") {
                    expect(buildModel(isPermanentlyClosed: nil)) == expectedModel
                }
            }

            context("else") {
                it("returns a SearchEntityModel with the args' values") {
                    expect(buildModel(isPermanentlyClosed: false)) == expectedModel
                }
            }

        }

    }

}
// swiftlint:enable blanket_disable_command
