//
//  YelpRequestService.swift
//  PlacesFinder
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
import Shared

actor YelpRequestService: PlaceLookupServiceProtocol {

    private typealias YelpServiceResult = DecodableServiceResult<YelpPageResponse, YelpErrorPayload>

    static let maxResultsPerPage = YelpRequestBuilder.maxResultsPerPage

    private let decodableService: DecodableServiceProtocol
    private let requestBuilder: YelpRequestBuilder

    init(config: YelpRequestConfig,
         decodableService: DecodableServiceProtocol) {
        self.decodableService = decodableService
        self.requestBuilder = YelpRequestBuilder(config: config)
    }

    nonisolated func buildInitialPageRequestToken(
        placeLookupParams: PlaceLookupParams,
        resultsPerPage: Int
    ) throws -> PlaceLookupPageRequestToken {
        let tokenResult = requestBuilder.buildPageRequestToken(placeLookupParams,
                                                               startingIndex: 0,
                                                               resultsPerPage: resultsPerPage)
        return try tokenResult.get()
    }

    nonisolated func buildInitialPageRequestToken(
        placeLookupParams: PlaceLookupParams
    ) throws -> PlaceLookupPageRequestToken {
        return try buildInitialPageRequestToken(placeLookupParams: placeLookupParams,
                                                resultsPerPage: YelpRequestService.maxResultsPerPage)
    }

    func requestPage(requestToken: PlaceLookupPageRequestToken) async -> PlaceLookupResult {
        let result: YelpServiceResult = await decodableService.performRequest(urlRequest: requestToken.urlRequest)

        switch result {
        case let .success(yelpPageResponse):
            return handleRequestSuccess(requestToken: requestToken,
                                        yelpPageResponse: yelpPageResponse)

        case let .failure(error):
            switch error {
            case let .errorPayloadReturned(yelpErrorPayload, urlResponse):
                return .failure(.errorPayloadReturned(yelpErrorPayload.placeLookupErrorPayload,
                                                      urlResponse: urlResponse))

            case let .unexpected(decodingError):
                return .failure(.unexpectedDecodingError(underlyingError: decodingError))
            }
        }
    }

    private func handleRequestSuccess(requestToken: PlaceLookupPageRequestToken,
                                      yelpPageResponse: YelpPageResponse) -> PlaceLookupResult {
        let page = yelpPageResponse.lookupPage
        let nextRequestTokenResult = buildNextRequestToken(totalResults: yelpPageResponse.total,
                                                           previousToken: requestToken)
        let placeLookupResponse = PlaceLookupResponse(page: page,
                                                      nextRequestTokenResult: nextRequestTokenResult)

        return .success(placeLookupResponse)
    }

    private func buildNextRequestToken(
        totalResults: Int,
        previousToken: PlaceLookupPageRequestToken
    ) -> PlaceLookupPageRequestTokenResult? {
        let nextStartingIndex = previousToken.startingIndex + previousToken.resultsPerPage
        guard totalResults > nextStartingIndex else { return nil }

        return requestBuilder.buildPageRequestToken(previousToken.placeLookupParams,
                                                    startingIndex: nextStartingIndex,
                                                    resultsPerPage: previousToken.resultsPerPage)
    }

}

// MARK: Yelp-specific result components

// Complete payload details at https://www.yelp.com/developers/documentation/v3/business_search
private struct YelpPageResponse: Decodable {
    /// Total number of businesses that Yelp found matching the search criteria. This is NOT necessarily equal to
    /// businesses.count, as Yelp returns at most 50 results per request. Additional requests may be needed to fetch
    /// all matching businesses.
    let total: Int

    // FailableDecodable is used to prevent one bad apple from ruining the whole bunch (i.e., every single YelpBusiness
    // in the payload failing to decode!)
    let businesses: [FailableDecodable<YelpBusiness>]
}

extension YelpPageResponse {

    var lookupPage: PlaceLookupPage {
        let entities: [PlaceLookupEntity] = businesses.compactMap {
            guard let business = $0.value else { return nil }

            return PlaceLookupEntity(
                id: business.id,
                name: business.name,
                addressLines: business.location?.value?.placeLookupAddressLines,
                displayPhone: business.display_phone?.value,
                dialablePhone: business.phone?.value,
                url: business.url,
                ratingFields: business.ratingFields,
                pricing: business.pricing,
                coordinate: business.coordinates?.value?.coordinate,
                isPermanentlyClosed: business.is_closed?.value,
                image: business.image_url?.value
            )
        }

        return PlaceLookupPage(entities: entities)
    }

}

// swiftlint:disable identifier_name

private struct YelpBusiness: Decodable {
    let id: NonEmptyString
    let name: NonEmptyString
    let location: FailableDecodable<YelpLocation>?
    let phone: FailableDecodable<NonEmptyString>?
    let display_phone: FailableDecodable<NonEmptyString>?
    let url: URL
    let rating: FailableDecodable<Double>?
    let review_count: FailableDecodable<Int>?
    let price: FailableDecodable<String>?
    let coordinates: FailableDecodable<YelpCoordinate>?
    let is_closed: FailableDecodable<Bool>?
    let image_url: FailableDecodable<URL>?
}

extension YelpBusiness {

    static let maxRating: Double = 5.0
    static let pricingRange = 1...4

    var ratingFields: PlaceLookupRatingFields? {
        guard let rating = rating?.value,
            let numRatings = review_count?.value
        else {
            return nil
        }

        let averageRating = Percentage(decimalOf: rating / YelpBusiness.maxRating)
        return PlaceLookupRatingFields(averageRating: averageRating,
                                       numRatings: numRatings)
    }

    var pricing: PlaceLookupPricing? {
        guard let price = price?.value,
            YelpBusiness.pricingRange ~= price.count,
            CharacterSet(charactersIn: price) == CharacterSet(charactersIn: "$")
        else {
            return nil
        }

        return PlaceLookupPricing(count: price.count,
                                  maximum: YelpBusiness.pricingRange.upperBound)
    }

}

private struct YelpCoordinate: Decodable {
    let longitude: Double
    let latitude: Double
}

extension YelpCoordinate {

    var coordinate: PlaceLookupCoordinate {
        return PlaceLookupCoordinate(latitude: latitude,
                                     longitude: longitude)
    }

}

private struct YelpLocation: Decodable {
    let display_address: [String]
}

extension YelpLocation {

    var placeLookupAddressLines: PlaceLookupAddressLines? {
        return NonEmptyArray(display_address.compactMap { try? NonEmptyString($0) })
    }

}

// swiftlint:enable identifier_name

// MARK: Yelp-specific error components

private struct YelpErrorDetails: Decodable {
    let code: String
    let description: String
}

private struct YelpErrorPayload: Decodable {
    let error: YelpErrorDetails
}

extension YelpErrorPayload {

    var placeLookupErrorPayload: PlaceLookupErrorPayload {
        return .codeAndDescription(code: error.code, description: error.description)
    }

}
