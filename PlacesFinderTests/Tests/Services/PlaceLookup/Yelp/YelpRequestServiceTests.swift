//
//  YelpRequestServiceTests.swift
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
// swiftlint:disable file_length
// swiftlint:disable force_unwrapping
// swiftlint:disable function_body_length
// swiftlint:disable implicitly_unwrapped_optional
// swiftlint:disable line_length
// swiftlint:disable type_body_length
class YelpRequestServiceTests: AsyncSpec {

    private typealias DecodableServiceMock = DecodableServiceProtocolMock<YelpPageResponse, YelpErrorPayload>

    override class func spec() {

        let stubAPIKey = "stubAPIKey"
        let stubBaseURL = URL(string: "https://api.yelp.com")!

        // These are the params that were used to fetch the payloads in Data/YelpAPIMocks/Thai
        let stubParams = PlaceLookupParams(keywords: .stubValue("Thai"),
                                           coordinate: PlaceLookupCoordinate(latitude: 37.3348,
                                                                             longitude: -122.009),
                                           radius: .init(value: 16_093, unit: .meters),
                                           sorting: .distance)

        var mockDecodableService: DecodableServiceMock!
        var sut: YelpRequestService!

        func urlString(offset: Int,
                       limit: Int) -> String {
            return "https://api.yelp.com/v3/businesses/search"
                + "?term=Thai&latitude=37.3348&longitude=-122.009&radius=16093&sort_by=distance"
                + "&offset=\(offset)&limit=\(limit)"
        }

        func decodePageResponse(_ data: Data) -> YelpPageResponse? {
            do {
                return try JSONDecoder().decode(YelpPageResponse.self, from: data)
            } catch {
                fail("Unexpected error: \(error)")
                return nil
            }
        }

        func loadPageResponse(_ resource: String,
                              subdirectory: String) -> YelpPageResponse? {
            let bundle = Bundle(for: YelpRequestServiceTests.self)
            guard let url = bundle.url(forResource: resource,
                                       withExtension: "json",
                                       subdirectory: "YelpAPIMocks/\(subdirectory)"),
                let data = try? Data(contentsOf: url)
            else {
                fail("Unable to load \(subdirectory)/\(resource).json")
                return nil
            }

            return decodePageResponse(data)
        }

        func stubBusinessJSON(id: String,
                              isClosed: Bool? = false) -> String {
            let isClosedField = isClosed.map { "\"is_closed\": \($0)," } ?? ""

            return """
            {
                "id": "\(id)",
                "name": "Stub Business",
                \(isClosedField)
                "url": "https://www.example.com/biz",
                "image_url": "https://www.example.com/image.jpg",
                "rating": 4.5,
                "review_count": 10
            }
            """
        }

        func stubPageResponse(total: Int,
                              businesses: [String]) -> YelpPageResponse? {
            let json = """
            {
                "total": \(total),
                "businesses": [\(businesses.joined(separator: ","))]
            }
            """

            return decodePageResponse(Data(json.utf8))
        }

        beforeEach {
            mockDecodableService = DecodableServiceProtocolMock()

            do {
                let config = try YelpRequestConfig(apiKey: stubAPIKey,
                                                   baseURL: stubBaseURL)
                sut = YelpRequestService(config: config,
                                         decodableService: mockDecodableService)
            } catch {
                fail("Unexpected error: \(error)")
            }
        }

        describe("buildInitialPageRequestToken(placeLookupParams:)") {

            var result: PlaceLookupPageRequestToken!

            beforeEach {
                result = try? sut.buildInitialPageRequestToken(placeLookupParams: stubParams)
            }

            it("returns a token with the placeLookupParams arg") {
                expect(result.placeLookupParams) == stubParams
            }

            it("returns a token requesting the maximum number of results per page") {
                expect(result.startingIndex) == 0
                expect(result.resultsPerPage) == 50
                expect(result.urlRequest.url?.absoluteString) == urlString(offset: 0, limit: 50)
            }

            it("returns a token with a GET request that's authorized with the API key") {
                expect(result.urlRequest.httpMethod) == "GET"
                expect(result.urlRequest.value(forHTTPHeaderField: "Authorization")) == "Bearer \(stubAPIKey)"
            }

        }

        describe("requestPage()") {

            var stubRequestToken: PlaceLookupPageRequestToken!
            var result: PlaceLookupResult!

            var returnedResponse: PlaceLookupResponse? {
                return try? result?.get()
            }

            var returnedEntities: [SearchEntityModel]? {
                return returnedResponse?.page.entities
            }

            func performTest() async {
                result = await sut.requestPage(requestToken: stubRequestToken)
            }

            beforeEach {
                stubRequestToken = try? sut.buildInitialPageRequestToken(placeLookupParams: stubParams)
                result = nil
            }

            it("calls decodableService.performRequest() with the token's URLRequest") {
                mockDecodableService.performRequestUrlRequestReturnValue =
                    .failure(.unexpected(.noDataReturned(HTTPURLResponse.stubValue())))

                await performTest()

                expect(mockDecodableService.performRequestUrlRequestReceivedInvocations) == [stubRequestToken.urlRequest]
            }

            context("when decodableService.performRequest() returns .errorPayloadReturned") {

                let stubURLResponse = HTTPURLResponse.stubValue(statusCode: 400)

                beforeEach {
                    let errorDetails = YelpErrorDetails(code: "stubCode",
                                                        description: "stubDescription")
                    mockDecodableService.performRequestUrlRequestReturnValue =
                        .failure(.errorPayloadReturned(YelpErrorPayload(error: errorDetails), stubURLResponse))

                    await performTest()
                }

                it("returns .errorPayloadReturned, with the payload's code and description, and the URL response") {
                    guard case let .failure(.errorPayloadReturned(payload, urlResponse))? = result,
                        case let .codeAndDescription(code, description) = payload
                    else {
                        fail("Unexpected value: \(String(describing: result))")
                        return
                    }

                    expect(code) == "stubCode"
                    expect(description) == "stubDescription"
                    expect(urlResponse) === stubURLResponse
                }

            }

            context("when decodableService.performRequest() returns .unexpected") {

                beforeEach {
                    mockDecodableService.performRequestUrlRequestReturnValue =
                        .failure(.unexpected(.noDataReturned(HTTPURLResponse.stubValue())))

                    await performTest()
                }

                it("returns .unexpectedDecodingError, with the underlying error") {
                    guard case .failure(.unexpectedDecodingError(.noDataReturned))? = result else {
                        fail("Unexpected value: \(String(describing: result))")
                        return
                    }
                }

            }

            context("when decodableService.performRequest() returns the payload in Thai/Page_1.json") {

                beforeEach {
                    mockDecodableService.performRequestUrlRequestReturnValue =
                        loadPageResponse("Page_1", subdirectory: "Thai").map { .success($0) }

                    await performTest()
                }

                // The payload has 50 businesses, none of which are permanently closed
                it("returns an entity for each business in the payload") {
                    expect(returnedEntities?.count) == 50
                }

                it("returns the entities in the same order as the payload") {
                    expect(returnedEntities?.prefix(3).map { $0.id.value }) == [
                        "jNGUpaFaWX4-nTK-z0IYjg",
                        "1F3AI_bPzsttQHAOwR9Q-A",
                        "3hWiHOsN8obXuZJL_15fZQ",
                    ]
                    expect(returnedEntities?.last?.id.value) == "oTRQsmZ7ac9V5Zs8wt8x_A"
                }

                it("returns a nil image for businesses that have no image") {
                    let imagelessIDs: Set<String> = [
                        "zXCta1P2Xv43sw-Lo5kMYw",    // "image_url": ""
                        "icQi0anMKE7ix4VOMRWyfQ",    // Same as above
                        "f0YqSx9HUXbSkKsrqoWSyQ",    // Same as above
                        "KjGCxB742V7Z2e1KhFeuOg",    // Same as above
                        "dCos-4Ln0FHKco6H-ilQPg",    // Same as above
                    ]
                    let returnedImagelessIDs = Set(
                        returnedEntities?.filter { $0.image == nil }.map { $0.id.value } ?? []
                    )

                    expect(returnedImagelessIDs) == imagelessIDs
                }

                it("returns all fields of a business that has all of them") {
                    let entity = returnedEntities?.first { $0.id.value == "jNGUpaFaWX4-nTK-z0IYjg" }

                    expect(entity) == SearchEntityModel(
                        id: .stubValue("jNGUpaFaWX4-nTK-z0IYjg"),
                        name: .stubValue("Pineapple Thai"),
                        url: URL(string: "https://www.yelp.com/biz/pineapple-thai-cupertino?adjust_creative=8nY0AbcnTbnIj6Jvoj0uzw&utm_campaign=yelp_api_v3&utm_medium=api_v3_business_search&utm_source=8nY0AbcnTbnIj6Jvoj0uzw")!,
                        // "rating": 3.9
                        ratings: SearchRatings(average: .four, numRatings: 1112),
                        image: URL(string: "https://s3-media0.fl.yelpcdn.com/bphoto/YAjlw7vB0FtjxAOt05-TJw/o.jpg")!,
                        addressLines: NonEmptyArray([
                            .stubValue("19369 Stevens Creek Blvd"),
                            .stubValue("Ste 120"),
                            .stubValue("Cupertino, CA 95014"),
                        ]),
                        displayPhone: .stubValue("(669) 240-5556"),
                        dialablePhone: .stubValue("+16692405556"),
                        // "price": "$$"
                        pricing: PlaceLookupPricing(count: 2),
                        coordinate: PlaceLookupCoordinate(latitude: 37.3234481, longitude: -122.0092386)
                    )
                }

                it("returns nil for the phone fields of a business whose phone values are empty") {
                    let entity = returnedEntities?.first { $0.id.value == "0XFpMm-3w1SVW5h3Hj50Yw" }

                    expect(entity) == SearchEntityModel(
                        id: .stubValue("0XFpMm-3w1SVW5h3Hj50Yw"),
                        name: .stubValue("Ruby Thai Kitchen"),
                        url: URL(string: "https://www.yelp.com/biz/ruby-thai-kitchen-santa-clara?adjust_creative=8nY0AbcnTbnIj6Jvoj0uzw&utm_campaign=yelp_api_v3&utm_medium=api_v3_business_search&utm_source=8nY0AbcnTbnIj6Jvoj0uzw")!,
                        // "rating": 2.4
                        ratings: SearchRatings(average: .twoAndAHalf, numRatings: 268),
                        image: URL(string: "https://s3-media0.fl.yelpcdn.com/bphoto/-alne5EFwqxlCO3EGKKMQQ/o.jpg")!,
                        addressLines: NonEmptyArray([
                            .stubValue("2855 Stevens Creek Blvd"),
                            .stubValue("Santa Clara, CA 95128"),
                        ]),
                        // "phone": "", "display_phone": ""
                        displayPhone: nil,
                        dialablePhone: nil,
                        // "price": "$"
                        pricing: PlaceLookupPricing(count: 1),
                        coordinate: PlaceLookupCoordinate(latitude: 37.326185, longitude: -121.944765)
                    )
                }

                it("returns nil for the pricing of a business that has no price value") {
                    let entity = returnedEntities?.first { $0.id.value == "0vpwSAk37ZQR1tESF1H1RA" }

                    expect(entity?.name.value) == "Thai Chicken-n-Rice"
                    expect(entity?.pricing) == nil
                }

                it("returns nil for the ratings of a business that hasn't been rated") {
                    // "rating": 0, "review_count": 0
                    let entity = returnedEntities?.first { $0.id.value == "ZZJSk-LVtR4-wpiWoBVwuw" }

                    expect(entity?.name.value) == "JFC"
                    expect(entity?.ratings) == nil
                }

                // The payload has "total": 905
                it("returns a token for requesting the next page of results") {
                    let nextRequestToken = try? returnedResponse?.nextRequestTokenResult?.get()

                    expect(nextRequestToken?.placeLookupParams) == stubParams
                    expect(nextRequestToken?.startingIndex) == 50
                    expect(nextRequestToken?.resultsPerPage) == 50
                    expect(nextRequestToken?.urlRequest.url?.absoluteString) == urlString(offset: 50, limit: 50)
                }

            }

            context("when the payload's total exceeds the results requested so far by fewer than a full page") {

                beforeEach {
                    stubRequestToken = PlaceLookupPageRequestToken(placeLookupParams: stubParams,
                                                                   urlRequest: .stubValue(),
                                                                   startingIndex: 50,
                                                                   resultsPerPage: 50)
                    mockDecodableService.performRequestUrlRequestReturnValue =
                        stubPageResponse(total: 101,
                                         businesses: [stubBusinessJSON(id: "stubID")]).map { .success($0) }

                    await performTest()
                }

                it("returns a token for requesting the next page of results") {
                    let nextRequestToken = try? returnedResponse?.nextRequestTokenResult?.get()

                    expect(nextRequestToken?.startingIndex) == 100
                    expect(nextRequestToken?.resultsPerPage) == 50
                    expect(nextRequestToken?.urlRequest.url?.absoluteString) == urlString(offset: 100, limit: 50)
                }

            }

            context("when the payload's total doesn't exceed the results requested so far") {

                beforeEach {
                    stubRequestToken = PlaceLookupPageRequestToken(placeLookupParams: stubParams,
                                                                   urlRequest: .stubValue(),
                                                                   startingIndex: 50,
                                                                   resultsPerPage: 50)
                    mockDecodableService.performRequestUrlRequestReturnValue =
                        stubPageResponse(total: 100,
                                         businesses: [stubBusinessJSON(id: "stubID")]).map { .success($0) }

                    await performTest()
                }

                it("returns the payload's entities") {
                    expect(returnedEntities?.map { $0.id.value }) == ["stubID"]
                }

                it("returns nil for the next request token") {
                    expect(returnedResponse) != nil
                    expect(returnedResponse?.nextRequestTokenResult) == nil
                }

            }

            // Yelp rejects any request in which offset + limit is greater than 240

            context("when the next page would extend past Yelp's maximum for offset + limit") {

                beforeEach {
                    stubRequestToken = PlaceLookupPageRequestToken(placeLookupParams: stubParams,
                                                                   urlRequest: .stubValue(),
                                                                   startingIndex: 150,
                                                                   resultsPerPage: 50)
                    mockDecodableService.performRequestUrlRequestReturnValue =
                        stubPageResponse(total: 905,
                                         businesses: [stubBusinessJSON(id: "stubID")]).map { .success($0) }

                    await performTest()
                }

                it("returns a token requesting only the results up to that maximum") {
                    let nextRequestToken = try? returnedResponse?.nextRequestTokenResult?.get()

                    expect(nextRequestToken?.startingIndex) == 200
                    expect(nextRequestToken?.resultsPerPage) == 40
                    expect(nextRequestToken?.urlRequest.url?.absoluteString) == urlString(offset: 200, limit: 40)
                }

            }

            context("when the results requested so far have reached Yelp's maximum for offset + limit") {

                beforeEach {
                    stubRequestToken = PlaceLookupPageRequestToken(placeLookupParams: stubParams,
                                                                   urlRequest: .stubValue(),
                                                                   startingIndex: 200,
                                                                   resultsPerPage: 40)
                    mockDecodableService.performRequestUrlRequestReturnValue =
                        stubPageResponse(total: 905,
                                         businesses: [stubBusinessJSON(id: "stubID")]).map { .success($0) }

                    await performTest()
                }

                it("returns the payload's entities") {
                    expect(returnedEntities?.map { $0.id.value }) == ["stubID"]
                }

                it("returns .maxResultsOffsetExceeded in place of a next request token") {
                    guard case .failure(.maxResultsOffsetExceeded)? = returnedResponse?.nextRequestTokenResult else {
                        fail("Unexpected value: \(String(describing: returnedResponse?.nextRequestTokenResult))")
                        return
                    }
                }

            }

            context("when the payload has a business that is permanently closed") {

                beforeEach {
                    let businesses = [
                        stubBusinessJSON(id: "stubID_0"),
                        stubBusinessJSON(id: "stubID_1", isClosed: true),
                        stubBusinessJSON(id: "stubID_2"),
                    ]
                    mockDecodableService.performRequestUrlRequestReturnValue =
                        stubPageResponse(total: 3, businesses: businesses).map { .success($0) }

                    await performTest()
                }

                it("omits that business") {
                    expect(returnedEntities?.map { $0.id.value }) == ["stubID_0", "stubID_2"]
                }

            }

            context("when the payload has a business with no is_closed value") {

                beforeEach {
                    let businesses = [
                        stubBusinessJSON(id: "stubID_0"),
                        stubBusinessJSON(id: "stubID_1", isClosed: nil),
                        stubBusinessJSON(id: "stubID_2"),
                    ]
                    mockDecodableService.performRequestUrlRequestReturnValue =
                        stubPageResponse(total: 3, businesses: businesses).map { .success($0) }

                    await performTest()
                }

                it("returns an entity for that business") {
                    expect(returnedEntities?.map { $0.id.value }) == ["stubID_0", "stubID_1", "stubID_2"]
                }

            }

            context("when the payload has a business that can't be decoded") {

                beforeEach {
                    let businesses = [
                        stubBusinessJSON(id: "stubID_0"),
                        stubBusinessJSON(id: ""),
                        stubBusinessJSON(id: "stubID_2"),
                    ]
                    mockDecodableService.performRequestUrlRequestReturnValue =
                        stubPageResponse(total: 3, businesses: businesses).map { .success($0) }

                    await performTest()
                }

                it("omits that business, without affecting the other businesses") {
                    expect(returnedEntities?.map { $0.id.value }) == ["stubID_0", "stubID_2"]
                }

            }

        }

    }

}
// swiftlint:enable blanket_disable_command
