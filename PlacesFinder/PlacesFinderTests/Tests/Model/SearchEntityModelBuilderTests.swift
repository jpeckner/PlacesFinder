//
//  SearchEntityModelBuilderTests.swift
//  PlacesFinderTests
//
//  Created by Justin Peckner.
//  Copyright © 2019 Justin Peckner. All rights reserved.
//

import CoreLocation
import Nimble
#if DEBUG
@testable import PlacesFinder
#endif
import Quick
import Shared
import SharedTestComponents
import SwiftDuxTestComponents

class SearchEntityModelBuilderTests: QuickSpec {

    // swiftlint:disable function_body_length
    // swiftlint:disable implicitly_unwrapped_optional
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

                it("returns the entity's values in SearchSummaryModel") {
                    expect(result?.summaryModel) == SearchSummaryModel(name: .stubValue("stubEntityName"),
                                                                       ratings: .stubValue(average: .five,
                                                                                           numRatings: 123),
                                                                       pricing: .stubValue(),
                                                                       image: .stubValue())
                }

                it("returns the entity's values in SearchDetailsModel") {
                    expect(result?.detailsModel) == SearchDetailsModel(name: .stubValue("stubEntityName"),
                                                                       addressLines: .stubValue(),
                                                                       displayPhone: .stubValue("stubDisplayPhone"),
                                                                       dialablePhone: .stubValue("stubDialablePhone"),
                                                                       url: .stubValue(),
                                                                       ratings: .stubValue(average: .five,
                                                                                           numRatings: 123),
                                                                       pricing: .stubValue(),
                                                                       coordinate: .stubValue(),
                                                                       image: .stubValue())
                }
            }

        }

    }

}
