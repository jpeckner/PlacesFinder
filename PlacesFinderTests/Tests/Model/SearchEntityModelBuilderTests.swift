//
//  SearchEntityModelBuilderTests.swift
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

import CoreLocation
import Nimble
import Quick
import Shared
import SharedTestComponents
import SwiftDuxTestComponents

// swiftlint:disable blanket_disable_command
// swiftlint:disable implicitly_unwrapped_optional
class SearchEntityModelBuilderTests: QuickSpec {

    override func spec() {

        var builder: SearchEntityModelBuilder!

        beforeEach {
            builder = SearchEntityModelBuilder()
        }

        describe("buildEntityModel") {

            var result: SearchEntityModel?

            context("when the entity arg's isPermanentlyClosed value is nil") {
                beforeEach {
                    let entity = PlaceLookupEntity.stubValue(isPermanentlyClosed: nil)
                    result = builder.buildEntityModel(entity)
                }

                it("returns nil") {
                    expect(result).to(beNil())
                }
            }

            context("else when the entity arg's isPermanentlyClosed value is true") {
                beforeEach {
                    let entity = PlaceLookupEntity.stubValue(isPermanentlyClosed: true)
                    result = builder.buildEntityModel(entity)
                }

                it("returns nil") {
                    expect(result).to(beNil())
                }
            }

            context("else when the entity arg's ratingsField value is nil") {
                beforeEach {
                    let entity = PlaceLookupEntity.stubValue(ratingFields: nil)
                    result = builder.buildEntityModel(entity)
                }

                it("returns nil") {
                    expect(result).to(beNil())
                }
            }

            context("else when the entity arg's image value is nil") {
                beforeEach {
                    let entity = PlaceLookupEntity.stubValue(image: nil)
                    result = builder.buildEntityModel(entity)
                }

                it("returns nil") {
                    expect(result).to(beNil())
                }
            }

            context("else when the entity arg's ratings value is not a member of SearchRatingsValue") {
                beforeEach {
                    let ratingFields = PlaceLookupRatingFields(averageRating: Percentage(decimalOf: 0.35),
                                                               numRatings: 123)
                    let entity = PlaceLookupEntity.stubValue(ratingFields: ratingFields)
                    result = builder.buildEntityModel(entity)
                }

                it("returns nil") {
                    expect(result).to(beNil())
                }
            }

            context("else") {
                let ratingFields = PlaceLookupRatingFields(averageRating: Percentage.oneHundredPercent,
                                                           numRatings: 123)
                let stubEntity = PlaceLookupEntity.stubValue(ratingFields: ratingFields)

                beforeEach {
                    result = builder.buildEntityModel(stubEntity)
                }

                it("returns the entity's values in SearchEntityModel") {
                    expect(result) == SearchEntityModel(id: stubEntity.id,
                                                        name: .stubValue("stubEntityName"),
                                                        url: .stubValue(),
                                                        ratings: .stubValue(average: .five, numRatings: 123),
                                                        image: .stubValue(),
                                                        addressLines: .stubValue(),
                                                        displayPhone: .stubValue("stubDisplayPhone"),
                                                        dialablePhone: .stubValue("stubDialablePhone"),
                                                        pricing: .stubValue(),
                                                        coordinate: .stubValue())
                }
            }

        }

    }

}
// swiftlint:enable blanket_disable_command
