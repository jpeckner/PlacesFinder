//
//  PlaceLookupResponse+Stub.swift
//  SharedTestComponents
//
//  Created by Justin Peckner.
//  Copyright © 2019 Justin Peckner. All rights reserved.
//

import Shared

// swiftlint:disable force_unwrapping

extension PlaceLookupParams {

    static func stubValue(keywords: NonEmptyString = NonEmptyString.stubValue("Thai food"),
                          coordinate: PlaceLookupCoordinate = .init(latitude: 10.0, longitude: 10.0),
                          radius: PlaceLookupDistance = .init(value: 10_000, unit: .meters),
                          sorting: PlaceLookupSorting = .bestMatch) -> PlaceLookupParams {
        return PlaceLookupParams(keywords: keywords,
                                 coordinate: coordinate,
                                 radius: radius,
                                 sorting: sorting)
    }

}

extension PlaceLookupRatingFields {

    static func stubValue(averageRating: Percentage = .init(decimalOf: 0.7),
                          numRatings: Int = 123) -> PlaceLookupRatingFields {
        return PlaceLookupRatingFields(averageRating: averageRating,
                                       numRatings: numRatings)
    }

}

extension PlaceLookupAddressLines {

    static func stubValue() -> PlaceLookupAddressLines {
        return NonEmptyArray([
            NonEmptyString.stubValue("stubAddressLine1"),
            NonEmptyString.stubValue("stubAddressLine2"),
        ])!
    }

}

extension PlaceLookupPricing {

    static func stubValue(count: Int = 5,
                          maximum: Int = 10) -> PlaceLookupPricing {
        return PlaceLookupPricing(count: count,
                                  maximum: maximum)
    }

}

extension PlaceLookupCoordinate {

    static func stubValue(latitude: Double = 45.0,
                          longitude: Double = 90.0) -> PlaceLookupCoordinate {
        return PlaceLookupCoordinate(latitude: latitude,
                                     longitude: longitude)
    }

}

extension PlaceLookupEntity {

    // swiftlint:disable identifier_name
    static func stubValue(id: NonEmptyString = .stubValue("stubID"),
                          name: NonEmptyString = .stubValue("stubEntityName"),
                          addressLines: PlaceLookupAddressLines? = .stubValue(),
                          displayPhone: NonEmptyString? = .stubValue("stubDisplayPhone"),
                          dialablePhone: NonEmptyString? = .stubValue("stubDialablePhone"),
                          url: URL = .stubValue(),
                          ratingFields: PlaceLookupRatingFields? = .stubValue(),
                          pricing: PlaceLookupPricing? = .stubValue(),
                          coordinate: PlaceLookupCoordinate? = .stubValue(),
                          isPermanentlyClosed: Bool? = false,
                          image: URL? = .stubValue()) -> PlaceLookupEntity {
        return PlaceLookupEntity(id: id,
                                 name: name,
                                 addressLines: addressLines,
                                 displayPhone: displayPhone,
                                 dialablePhone: dialablePhone,
                                 url: url,
                                 ratingFields: ratingFields,
                                 pricing: pricing,
                                 coordinate: coordinate,
                                 isPermanentlyClosed: isPermanentlyClosed,
                                 image: image)
    }
    // swiftlint:enable identifier_name

}

extension PlaceLookupPage {

    static func stubValue(entities: [PlaceLookupEntity] = []) -> PlaceLookupPage {
        return PlaceLookupPage(entities: entities)
    }

}

extension PlaceLookupPageRequestToken {

    static func stubValue(placeLookupParams: PlaceLookupParams = .stubValue(),
                          urlRequest: URLRequest = .stubValue(),
                          startingIndex: Int = 0,
                          resultsPerPage: Int = 10) -> PlaceLookupPageRequestToken {
        return PlaceLookupPageRequestToken(placeLookupParams: placeLookupParams,
                                           urlRequest: urlRequest,
                                           startingIndex: startingIndex,
                                           resultsPerPage: resultsPerPage)
    }

}

extension PlaceLookupTokenAttemptsContainer {

    static func stubValue(token: PlaceLookupPageRequestToken = .stubValue(),
                          maxAttempts: Int = 10,
                          numAttemptsSoFar: Int = 5) -> PlaceLookupTokenAttemptsContainer {
        return PlaceLookupTokenAttemptsContainer(token: token,
                                                 maxAttempts: maxAttempts,
                                                 numAttemptsSoFar: numAttemptsSoFar)
    }

}

extension PlaceLookupResponse {

    static func stubValue(page: PlaceLookupPage = .stubValue(),
                          nextRequestTokenResult: PlaceLookupPageRequestTokenResult? = nil) -> PlaceLookupResponse {
        return PlaceLookupResponse(page: page,
                                   nextRequestTokenResult: nextRequestTokenResult)
    }

}
