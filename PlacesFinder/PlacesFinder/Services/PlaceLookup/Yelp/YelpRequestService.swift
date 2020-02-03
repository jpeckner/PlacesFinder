//
//  YelpRequestService.swift
//  Shared
//
//  Created by Justin Peckner.
//  Copyright © 2019 Justin Peckner. All rights reserved.
//

import Foundation
import Shared

class YelpRequestService: PlaceLookupServiceProtocol {

    private typealias YelpServiceResult = DecodableServiceResult<YelpPageResponse, YelpErrorPayload>

    static let maxResultsPerPage = YelpRequestBuilder.maxResultsPerPage

    private let decodableService: DecodableServiceProtocol
    private let requestBuilder: YelpRequestBuilder

    init(config: YelpRequestConfig,
         decodableService: DecodableServiceProtocol) {
        self.decodableService = decodableService
        self.requestBuilder = YelpRequestBuilder(config: config)
    }

    func buildInitialPageRequestToken(_ placeLookupParams: PlaceLookupParams,
                                      resultsPerPage: Int) throws -> PlaceLookupPageRequestToken {
        let tokenResult = requestBuilder.buildPageRequestToken(placeLookupParams,
                                                               startingIndex: 0,
                                                               resultsPerPage: resultsPerPage)
        return try tokenResult.get()
    }

    func buildInitialPageRequestToken(_ placeLookupParams: PlaceLookupParams) throws -> PlaceLookupPageRequestToken {
        return try buildInitialPageRequestToken(placeLookupParams,
                                                resultsPerPage: YelpRequestService.maxResultsPerPage)
    }

    func requestPage(_ requestToken: PlaceLookupPageRequestToken,
                     completion: @escaping PlaceLookupCompletion) {
        decodableService.performRequest(requestToken.urlRequest) { [weak self] (result: YelpServiceResult) in
            switch result {
            case let .success(yelpPageResponse):
                self?.handleRequestSuccess(requestToken,
                                           yelpPageResponse: yelpPageResponse,
                                           completion: completion)
            case let .failure(error):
                switch error {
                case let .errorPayloadReturned(yelpErrorPayload, urlResponse):
                    completion(.failure(.errorPayloadReturned(yelpErrorPayload.placeLookupErrorPayload,
                                                              urlResponse: urlResponse)))
                case let .unexpected(decodingError):
                    completion(.failure(.unexpectedDecodingError(underlyingError: decodingError)))
                }
            }
        }
    }

    private func handleRequestSuccess(_ requestToken: PlaceLookupPageRequestToken,
                                      yelpPageResponse: YelpPageResponse,
                                      completion: @escaping PlaceLookupCompletion) {
        let page = yelpPageResponse.lookupPage
        let nextRequestTokenResult = buildNextRequestToken(yelpPageResponse.total,
                                                           previousToken: requestToken)
        let placeLookupResponse = PlaceLookupResponse(page: page,
                                                      nextRequestTokenResult: nextRequestTokenResult)

        completion(.success(placeLookupResponse))
    }

    private func buildNextRequestToken(
        _ totalResults: Int,
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

private struct YelpErrorDetails: Decodable, Equatable {
    let code: String
    let description: String
}

private struct YelpErrorPayload: Decodable, Equatable {
    let error: YelpErrorDetails
}

extension YelpErrorPayload {

    var placeLookupErrorPayload: PlaceLookupErrorPayload {
        return .codeAndDescription(code: error.code, description: error.description)
    }

}
