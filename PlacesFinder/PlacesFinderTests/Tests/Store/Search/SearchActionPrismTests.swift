//
//  SearchActionPrismTests.swift
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
import SwiftDux

class SearchActionPrismTests: QuickSpec {

    // swiftlint:disable function_body_length
    // swiftlint:disable implicitly_unwrapped_optional
    override func spec() {

        let stubParams = PlaceLookupParams.stubValue()
        let stubSubmittedParams = SearchSubmittedParams(keywords: stubParams.keywords)
        let stubEntities = NonEmptyArray(with: SearchEntityModel.stubValue())
        let stubRequestToken = PlaceLookupPageRequestToken.stubValue()

        var mockPlaceLookupService: PlaceLookupServiceProtocolMock!
        var mockSearchEntityModelBuilder: SearchEntityModelBuilderProtocolMock!
        var prism: SearchActionPrism!

        var result: Action!

        beforeEach {
            SearchActionCreatorProtocolMock.setup()

            mockPlaceLookupService = PlaceLookupServiceProtocolMock()
            mockSearchEntityModelBuilder = SearchEntityModelBuilderProtocolMock()

            prism = SearchActionPrism(
                dependencies: SearchActionCreatorDependencies(placeLookupService: mockPlaceLookupService,
                                                              searchEntityModelBuilder: mockSearchEntityModelBuilder),
                actionCreator: SearchActionCreatorProtocolMock.self
            )
        }

        afterEach {
            SearchActionCreatorProtocolMock.resetAll()
        }

        describe("initialRequestAction()") {

            beforeEach {
                result = prism.initialRequestAction(stubSubmittedParams) { _ in }
            }

            it("calls actionCreator.requestInitialPage() with the args for the next page request") {
                let expectedTokenContainer = PlaceLookupTokenAttemptsContainer(token: stubRequestToken,
                                                                               maxAttempts: 5,
                                                                               numAttemptsSoFar: 5)
                SearchActionCreatorProtocolMock.verifyRequestInitialPageCalled(
                    with: stubSubmittedParams,
                    placeLookupService: mockPlaceLookupService,
                    actionCreator: SearchActionCreatorProtocolMock.self
                )
            }

            it("returns the action returned by actionCreator.requestInitialPage()") {
                expect(result as? StubSearchAction) == .requestInitialPage
            }

        }

        describe("subsequentRequestAction()") {

            var errorThrown: Error?
            var result: Action?

            func performTest(maxAttempts: Int,
                             numAttemptsSoFar: Int) {
                let tokenContainer = PlaceLookupTokenAttemptsContainer(token: stubRequestToken,
                                                                       maxAttempts: maxAttempts,
                                                                       numAttemptsSoFar: numAttemptsSoFar)
                errorThrown = errorThrownBy {
                    result = try prism.subsequentRequestAction(stubSubmittedParams,
                                                               allEntities: stubEntities,
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

                beforeEach {
                    performTest(maxAttempts: 5,
                                numAttemptsSoFar: 4)
                }

                it("does not throw an error") {
                    expect(errorThrown).to(beNil())
                }

                it("calls actionCreator.requestSubsequentPage() with the args for the next page request") {
                    let expectedTokenContainer = PlaceLookupTokenAttemptsContainer(token: stubRequestToken,
                                                                                   maxAttempts: 5,
                                                                                   numAttemptsSoFar: 5)
                    SearchActionCreatorProtocolMock.verifyRequestSubsequentPageCalled(
                        with: stubEntities.value,
                        nextRequestToken: expectedTokenContainer,
                        placeLookupService: mockPlaceLookupService,
                        actionCreator: SearchActionCreatorProtocolMock.self
                    )
                }

                it("returns the action returned by actionCreator.requestSubsequentPage()") {
                    expect(result as? StubSearchAction) == .requestSubsequentPage
                }

            }

        }

        describe("detailEntityAction") {
            let stubDetailsModel = SearchDetailsModel.stubValue()

            beforeEach {
                result = prism.detailEntityAction(stubDetailsModel)
            }

            it("returns SearchAction.detailedEntity(detailsModel:)") {
                expect(result as? SearchAction) == .detailedEntity(stubDetailsModel)
            }
        }

        describe("removeDetailedEntityAction") {
            beforeEach {
                result = prism.removeDetailedEntityAction
            }

            it("returns SearchAction.detailedEntity(detailsModel:)") {
                expect(result as? SearchAction) == .removeDetailedEntity
            }
        }

    }

}
