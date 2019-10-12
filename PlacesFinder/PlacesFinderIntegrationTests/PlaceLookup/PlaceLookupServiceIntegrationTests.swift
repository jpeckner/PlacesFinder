//
//  PlaceLookupServiceIntegrationTests.swift
//  SharedIntegrationTests
//
//  Created by Justin Peckner.
//  Copyright © 2018 Justin Peckner. All rights reserved.
//

import Foundation
import Nimble
import Quick
import Shared
import SharedTestComponents

class PlaceLookupServiceIntegrationTests: QuickSpec {

    // swiftlint:disable function_body_length
    // swiftlint:disable implicitly_unwrapped_optional
    override func spec() {

        let urlString = ProcessInfo().environment["PLACE_LOOKUP_BASE_URL"]
        let apiKeyString = ProcessInfo().environment["PLACE_LOOKUP_KEY"]

        let responseQueue = DispatchQueue(label: "PlaceLookupServiceIntegrationTests")
        let networkDataService = NetworkDataService(urlSession: URLSession.shared,
                                                    responseQueue: responseQueue)
        let httpService = HTTPService(networkDataService: networkDataService)
        let decodableService = DecodableService(httpService: httpService,
                                                decoder: JSONDecoder())

        let coordinate = LocationCoordinate(latitude: 34.052_601,
                                            longitude: -118.242_617)   // Downtown Los Angeles
        let params = PlaceLookupParams(keywords: NonEmptyString.stubValue("restaurants"),
                                       coordinate: coordinate,
                                       radius: .init(value: 400, unit: .meters),
                                       sorting: .distance)

        var placeLookupService: PlaceLookupService!
        var nextRequestToken: PlaceLookupPageRequestToken!

        func setupTest(apiKey: String) {
            guard let baseURLString = urlString,
                let baseURL = URL(string: baseURLString)
            else {
                fail("Invalid value for baseURL: \(String(describing: urlString))")
                return
            }

            do {
                let config = try YelpRequestConfig(apiKey: apiKey,
                                                   baseURL: baseURL)
                placeLookupService = PlaceLookupService(apiOption: .yelp(config),
                                                        decodableService: decodableService)
                nextRequestToken = try placeLookupService.buildInitialPageRequestToken(params)
            } catch {
                fail("Unexpected error: \(error)")
                return
            }
        }

        describe("requestPage") {

            context("when the request has a valid API key") {

                var pagesReturned: [PlaceLookupPage]!

                beforeSuite {
                    guard let apiKey = apiKeyString else {
                        fail("Invalid value for apiKeyString: \(String(describing: apiKeyString))")
                        return
                    }

                    setupTest(apiKey: apiKey)
                    pagesReturned = []

                    while let requestToken = nextRequestToken {
                        waitUntil(timeout: 5.0) { done in
                            placeLookupService.requestPage(requestToken) { result in
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
                }

                it("returns multiple unique pages from the API") {
                    expect(pagesReturned.isEmpty) == false
                    expect(Set(pagesReturned).count) == pagesReturned.count
                }

                it("returns the requested number of items per page for the first n-1 pages") {
                    for page in pagesReturned.dropLast() {
                        expect(page.entities.count) == PlaceLookupService.maxResultsPerPage
                    }
                }

                it("returns up to the requested number of items per page for the last page") {
                    expect(pagesReturned.last?.entities.count) <= PlaceLookupService.maxResultsPerPage
                }

            }

            context("when the request has an invalid API key") {

                var placeLookupResult: PlaceLookupResult!

                beforeSuite {
                    setupTest(apiKey: "")

                    waitUntil(timeout: 5.0) { done in
                        placeLookupService.requestPage(nextRequestToken) { result in
                            placeLookupResult = result
                            done()
                        }
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
