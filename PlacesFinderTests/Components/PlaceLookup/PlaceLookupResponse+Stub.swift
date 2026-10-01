//
//  PlaceLookupResponse+Stub.swift
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

import Foundation
import Shared

// swiftlint:disable blanket_disable_command
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

extension PlaceLookupAddressLines {

    static func stubValue() -> PlaceLookupAddressLines {
        return NonEmptyArray([
            NonEmptyString.stubValue("stubAddressLine1"),
            NonEmptyString.stubValue("stubAddressLine2"),
        ])!
    }

}

extension PlaceLookupPricing {

    static func stubValue(count: Int = 5) -> PlaceLookupPricing {
        return PlaceLookupPricing(count: count)
    }

}

extension PlaceLookupCoordinate {

    static func stubValue(latitude: Double = 45.0,
                          longitude: Double = 90.0) -> PlaceLookupCoordinate {
        return PlaceLookupCoordinate(latitude: latitude,
                                     longitude: longitude)
    }

}

extension PlaceLookupPage {

    static func stubValue(entities: [SearchEntityModel] = []) -> PlaceLookupPage {
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
// swiftlint:enable blanket_disable_command
