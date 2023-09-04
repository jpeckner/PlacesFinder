//
//  YelpRequestServiceIntegrationTests.swift
//  PlacesFinderIntegrationTests
//
//  Copyright (c) 2018 Justin Peckner
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
import SharedTestComponents

// swiftlint:disable blanket_disable_command
// swiftlint:disable function_body_length
// swiftlint:disable implicitly_unwrapped_optional
class YelpRequestServiceIntegrationTests: QuickSpec {

    override func spec() {

        let urlString = "https://api.yelp.com"
        let apiKeyString = ProcessInfo().environment["PLACE_LOOKUP_KEY"]

        let httpService = HTTPService(urlSession: URLSession.shared)
        let decodableService = DecodableService(httpService: httpService,
                                                decoder: JSONDecoder())

        let coordinate = LocationCoordinate(latitude: 34.052_601,
                                            longitude: -118.242_617)   // Downtown Los Angeles
        let params = PlaceLookupParams(keywords: NonEmptyString.stubValue("restaurants"),
                                       coordinate: coordinate,
                                       radius: .init(value: 400, unit: .meters),
                                       sorting: .distance)

        var placeLookupService: YelpRequestService!
        var nextRequestToken: PlaceLookupPageRequestToken!

        func setupTest(apiKey: String) {
            guard let baseURL = URL(string: urlString) else {
                fail("Invalid value for baseURL: \(String(describing: urlString))")
                return
            }

            do {
                let config = try YelpRequestConfig(apiKey: apiKey,
                                                   baseURL: baseURL)
                placeLookupService = YelpRequestService(config: config,
                                                        decodableService: decodableService)
                nextRequestToken = try placeLookupService.buildInitialPageRequestToken(placeLookupParams: params)
            } catch {
                fail("Unexpected error: \(error)")
                return
            }
        }

        describe("requestPage") {

            context("when the request has a valid API key") {

                var pagesReturned: [PlaceLookupPage]!

                beforeSuite {
                    pagesReturned = []

                    guard let apiKey = apiKeyString else {
                        fail("Invalid value for apiKeyString: \(String(describing: apiKeyString))")
                        return
                    }

                    setupTest(apiKey: apiKey)

                    while let requestToken = nextRequestToken {
                        await waitUntil(timeout: .seconds(5)) { done in
                            let result = await placeLookupService.requestPage(requestToken: requestToken)

                            switch result {
                            case let .success(response):
                                nextRequestToken = try? response.nextRequestTokenResult?.get()
                                pagesReturned.append(response.page)
                            case let .failure(error):
                                nextRequestToken = nil  // Prevent infinite looping
                                fail("Unexpected error: \(error)")
                            }

                            done()
                        }
                    }
                }

                it("returns multiple unique pages from the API") {
                    expect(pagesReturned.isEmpty) == false
                    expect(Set(pagesReturned).count) == pagesReturned.count
                }

                it("returns the requested number of items per page for the first n-1 pages") {
                    for page in pagesReturned.dropLast() {
                        expect(page.entities.count) == YelpRequestService.maxResultsPerPage
                    }
                }

                it("returns up to the requested number of items per page for the last page") {
                    expect(pagesReturned.last?.entities.count) <= YelpRequestService.maxResultsPerPage
                }

            }

            context("when the request has an invalid API key") {

                var placeLookupResult: PlaceLookupResult!

                beforeSuite {
                    setupTest(apiKey: "")

                    await waitUntil(timeout: .seconds(5)) { done in
                        placeLookupResult = await placeLookupService.requestPage(requestToken: nextRequestToken)
                        done()
                    }
                }

                it("returns an error message object") {
                    guard case let .failure(error)? = placeLookupResult,
                        case .errorPayloadReturned = error
                    else {
                        fail("Unexpected result: \(String(describing: placeLookupResult))")
                        return
                    }
                }

            }

        }

    }

}
// swiftlint:enable blanket_disable_command
