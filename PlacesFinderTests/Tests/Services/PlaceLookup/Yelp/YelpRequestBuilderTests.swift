//
//  YelpRequestBuilderTests.swift
//  PlacesFinderTests
//
//  Copyright (c) 2026 Justin Peckner
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
// swiftlint:disable force_unwrapping
// swiftlint:disable function_body_length
// swiftlint:disable implicitly_unwrapped_optional
class YelpRequestBuilderTests: AsyncSpec {

    override class func spec() {

        let stubAPIKey = "stubAPIKey"
        let stubBaseURL = URL(string: "https://api.yelp.com")!
        let stubParams = PlaceLookupParams(keywords: .stubValue("Thai"),
                                           coordinate: PlaceLookupCoordinate(latitude: 37.3348,
                                                                             longitude: -122.009),
                                           radius: .init(value: 16_093, unit: .meters),
                                           sorting: .distance)

        var sut: YelpRequestBuilder!
        var result: PlaceLookupPageRequestTokenResult!

        var returnedToken: PlaceLookupPageRequestToken? {
            return try? result?.get()
        }

        func urlString(offset: Int,
                       limit: Int) -> String {
            return "https://api.yelp.com/v3/businesses/search"
                + "?term=Thai&latitude=37.3348&longitude=-122.009&radius=16093&sort_by=distance"
                + "&offset=\(offset)&limit=\(limit)"
        }

        beforeEach {
            do {
                let config = try YelpRequestConfig(apiKey: stubAPIKey,
                                                   baseURL: stubBaseURL)
                sut = YelpRequestBuilder(config: config)
            } catch {
                fail("Unexpected error: \(error)")
            }
        }

        describe("buildPageRequestToken()") {

            for resultsPerPage in [0, 51] {

                context("when the resultsPerPage arg is \(resultsPerPage)") {
                    beforeEach {
                        result = sut.buildPageRequestToken(stubParams,
                                                           startingIndex: 0,
                                                           resultsPerPage: resultsPerPage)
                    }

                    it("returns .invalidResultsPerPageAmount, with the range of acceptable amounts") {
                        guard case let .failure(.invalidResultsPerPageAmount(acceptableRange))? = result else {
                            fail("Unexpected value: \(String(describing: result))")
                            return
                        }

                        expect(acceptableRange) == 1...50
                    }
                }

            }

            context("when the resultsPerPage arg is in the acceptable range") {

                beforeEach {
                    result = sut.buildPageRequestToken(stubParams,
                                                       startingIndex: 40,
                                                       resultsPerPage: 20)
                }

                it("returns a token with the placeLookupParams arg") {
                    expect(returnedToken?.placeLookupParams) == stubParams
                }

                it("returns a token with the startingIndex and resultsPerPage args") {
                    expect(returnedToken?.startingIndex) == 40
                    expect(returnedToken?.resultsPerPage) == 20
                }

                it("returns a token with a GET request for that page of search results") {
                    expect(returnedToken?.urlRequest.httpMethod) == "GET"
                    expect(returnedToken?.urlRequest.url?.absoluteString) == urlString(offset: 40, limit: 20)
                }

                it("returns a token with a request that's authorized with the API key") {
                    expect(returnedToken?.urlRequest.value(forHTTPHeaderField: "Authorization"))
                        == "Bearer \(stubAPIKey)"
                }

            }

            // Yelp rejects any request in which offset + limit is greater than 240

            context("when startingIndex + resultsPerPage equals Yelp's maximum") {

                beforeEach {
                    result = sut.buildPageRequestToken(stubParams,
                                                       startingIndex: 190,
                                                       resultsPerPage: 50)
                }

                it("returns a token requesting the full page") {
                    expect(returnedToken?.resultsPerPage) == 50
                    expect(returnedToken?.urlRequest.url?.absoluteString) == urlString(offset: 190, limit: 50)
                }

            }

            context("when startingIndex + resultsPerPage exceeds Yelp's maximum") {

                beforeEach {
                    result = sut.buildPageRequestToken(stubParams,
                                                       startingIndex: 200,
                                                       resultsPerPage: 50)
                }

                it("returns a token requesting only the results up to the maximum") {
                    expect(returnedToken?.startingIndex) == 200
                    expect(returnedToken?.resultsPerPage) == 40
                    expect(returnedToken?.urlRequest.url?.absoluteString) == urlString(offset: 200, limit: 40)
                }

            }

            for startingIndex in [240, 250] {

                context("when the startingIndex arg is \(startingIndex), leaving no results under Yelp's maximum") {
                    beforeEach {
                        result = sut.buildPageRequestToken(stubParams,
                                                           startingIndex: startingIndex,
                                                           resultsPerPage: 50)
                    }

                    it("returns .maxResultsOffsetExceeded") {
                        guard case .failure(.maxResultsOffsetExceeded)? = result else {
                            fail("Unexpected value: \(String(describing: result))")
                            return
                        }
                    }
                }

            }

        }

    }

}
// swiftlint:enable blanket_disable_command
