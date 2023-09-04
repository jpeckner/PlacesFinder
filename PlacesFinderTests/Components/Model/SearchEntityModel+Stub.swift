//
//  SearchEntityModel+Stub.swift
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
import SharedTestComponents

extension SearchRatings {

    static func stubValue(average: SearchRatingValue = .one,
                          numRatings: Int = 123) -> SearchRatings {
        return SearchRatings(average: average,
                             numRatings: numRatings)
    }

}

extension SearchEntityModel {

    static func stubValue(id: NonEmptyString = NonEmptyString.stubValue("stubID"),
                          name: String = "stubName",
                          url: URL = .stubValue(),
                          ratings: SearchRatings = .stubValue(),
                          image: URL = .stubValue(),
                          addressLines: PlaceLookupAddressLines = .stubValue(),
                          displayPhone: String? = "stubDisplayPhone",
                          dialablePhone: String? = "stubDialablePhone",
                          pricing: PlaceLookupPricing? = .stubValue(),
                          coordinate: PlaceLookupCoordinate? = .stubValue()) -> SearchEntityModel {
        return SearchEntityModel(id: id,
                                 name: NonEmptyString.stubValue(name),
                                 url: url,
                                 ratings: ratings,
                                 image: image,
                                 addressLines: addressLines,
                                 displayPhone: displayPhone.map { NonEmptyString.stubValue($0) },
                                 dialablePhone: dialablePhone.map { NonEmptyString.stubValue($0) },
                                 pricing: pricing,
                                 coordinate: coordinate)
    }
    // swiftlint:enable identifier_name

}
