// swiftlint:disable:this file_name
//
//  SearchDetailsViewModel+Stub.swift
//  PlacesFinderTests
//
//  Copyright (c) 2020 Justin Peckner
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

extension SearchDetailsBasicInfoViewModel {

    static func stubValue(image: DownloadedImageViewModel = DownloadedImageViewModel(url: .stubValue()),
                          name: NonEmptyString = .stubValue("stubName"),
                          address: NonEmptyString? = .stubValue("stubAddress"),
                          ratingsAverage: SearchRatingValue = .threeAndAHalf,
                          numRatingsMessage: String = "stubNumRatingsMessage",
                          pricing: String? = "stubPricing",
                          apiLinkCallback: OpenURLBlock? = nil) -> SearchDetailsBasicInfoViewModel {
        return SearchDetailsBasicInfoViewModel(image: image,
                                               name: name,
                                               address: address,
                                               ratingsAverage: ratingsAverage,
                                               numRatingsMessage: numRatingsMessage,
                                               pricing: pricing,
                                               apiLinkCallback: apiLinkCallback.map { IgnoredEquatable($0) })
    }

}

extension SearchDetailsMapCoordinateViewModel {

    static func stubValue(
        placeName: NonEmptyString = .stubValue("stubPlaceName"),
        address: NonEmptyString? = .stubValue("stubAddress"),
        coordinate: PlaceLookupCoordinate = .stubValue(),
        regionRadius: PlaceLookupDistance = .init(value: 123.0, unit: .meters)
    ) -> SearchDetailsMapCoordinateViewModel {
        return SearchDetailsMapCoordinateViewModel(placeName: placeName,
                                                   address: address,
                                                   coordinate: coordinate,
                                                   regionRadius: regionRadius)
    }

}
