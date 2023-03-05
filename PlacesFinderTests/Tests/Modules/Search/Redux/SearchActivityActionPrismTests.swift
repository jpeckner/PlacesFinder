//
//  SearchActivityActionPrismTests.swift
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
import SwiftDux

class SearchActivityActionPrismTests: QuickSpec {

    // swiftlint:disable function_body_length
    // swiftlint:disable implicitly_unwrapped_optional
    override func spec() {

        let stubParams = PlaceLookupParams.stubValue()
        let stubSearchParams = SearchParams(keywords: stubParams.keywords)
        let stubEntities = NonEmptyArray(with: SearchEntityModel.stubValue())
        let stubRequestToken = PlaceLookupPageRequestToken.stubValue()

        var mockPlaceLookupService: PlaceLookupServiceProtocolMock!
        var mockSearchEntityModelBuilder: SearchEntityModelBuilderProtocolMock!
        var mockDependencies: Search.ActivityActionCreatorDependencies!
        var prism: SearchActivityActionPrism!

        var result: Search.ActivityAction!

        beforeEach {
            mockPlaceLookupService = PlaceLookupServiceProtocolMock()
            mockSearchEntityModelBuilder = SearchEntityModelBuilderProtocolMock()
            mockDependencies = Search.ActivityActionCreatorDependencies(
                placeLookupService: mockPlaceLookupService,
                searchEntityModelBuilder: mockSearchEntityModelBuilder
            )

            prism = SearchActivityActionPrism(dependencies: mockDependencies)
        }

        describe("initialRequestAction()") {

            beforeEach {
                result = prism.initialRequestAction(searchParams: stubSearchParams) {
                    .success(.stubValue())
                }
            }

            it("returns Search.ActivityAction.startInitialRequest() with the args for the next page request") {
                expect(result) == .startInitialRequest(
                    dependencies: IgnoredEquatable(mockDependencies),
                    searchParams: stubSearchParams,
                    locationUpdateRequestBlock: IgnoredEquatable { .success(.stubValue()) }
                )
            }

        }

        describe("subsequentRequestAction()") {

            var errorThrown: Error?
            var result: Search.ActivityAction?

            func performTest(maxAttempts: Int,
                             numAttemptsSoFar: Int) {
                let tokenContainer = PlaceLookupTokenAttemptsContainer(token: stubRequestToken,
                                                                       maxAttempts: maxAttempts,
                                                                       numAttemptsSoFar: numAttemptsSoFar)
                errorThrown = errorThrownBy {
                    result = try prism.subsequentRequestAction(searchParams: stubSearchParams,
                                                               allEntities: stubEntities,
                                                               numPagesReceived: 1,
                                                               tokenContainer: tokenContainer)
                }
            }

            context("when incrementing the number of attempts would exceed the max number allowed") {

                beforeEach {
                    performTest(maxAttempts: 5,
                                numAttemptsSoFar: 5)
                }

                it("throws an error") {
                    expect(errorThrown).toNot(beNil())
                }

            }

            context("else when incrementing the number of attempts would not exceed the max number allowed") {

                let expectedTokenContainer = PlaceLookupTokenAttemptsContainer(token: stubRequestToken,
                                                                               maxAttempts: 5,
                                                                               numAttemptsSoFar: 5)

                beforeEach {
                    performTest(maxAttempts: 5,
                                numAttemptsSoFar: 4)
                }

                it("does not throw an error") {
                    expect(errorThrown).to(beNil())
                }

                it("returns Search.ActivityAction.startSubsequentRequest() with the args for the next page request") {
                    expect(result) == .startSubsequentRequest(
                        dependencies: IgnoredEquatable(mockDependencies),
                        params: .stubValue(
                            searchParams: stubSearchParams,
                            numPagesReceived: 1,
                            previousResults: stubEntities,
                            tokenContainer: expectedTokenContainer
                        )
                    )
                }

            }

        }

        describe("updateEditingAction") {
            let stubEditEvent: SearchBarEditEvent = .beganEditing

            beforeEach {
                result = prism.updateEditingAction(stubEditEvent)
            }

            it("returns Search.ActivityAction.updateInputEditing(editEvent:)") {
                expect(result) == .updateInputEditing(stubEditEvent)
            }
        }

        describe("detailEntityAction") {
            let stubEntity = SearchEntityModel.stubValue()

            beforeEach {
                result = prism.detailEntityAction(stubEntity)
            }

            it("returns Search.ActivityAction.detailedEntity(entity:)") {
                expect(result) == .detailedEntity(stubEntity)
            }
        }

        describe("removeDetailedEntityAction") {
            beforeEach {
                result = prism.removeDetailedEntityAction
            }

            it("returns Search.ActivityAction.detailedEntity(entity:)") {
                expect(result) == .removeDetailedEntity
            }
        }

    }

}
