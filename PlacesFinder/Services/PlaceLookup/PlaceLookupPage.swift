//
//  PlaceLookupPage.swift
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

typealias PlaceLookupAddressLines = NonEmptyArray<NonEmptyString>

struct PlaceLookupRatingFields: Hashable {
    let averageRating: Percentage
    let numRatings: Int
}

struct PlaceLookupPricing: Hashable {
    let count: Int       // I.e. 2 if this business' pricing is "$$"
    let maximum: Int     // I.e. 4 if the maximum pricing a business can have is "$$$$"
}

struct PlaceLookupEntity: Hashable {
    let id: NonEmptyString
    let name: NonEmptyString
    let addressLines: PlaceLookupAddressLines?
    let displayPhone: NonEmptyString?
    let dialablePhone: NonEmptyString?
    let url: URL
    let ratingFields: PlaceLookupRatingFields?
    let pricing: PlaceLookupPricing?
    let coordinate: PlaceLookupCoordinate?
    let isPermanentlyClosed: Bool?
    let image: URL?
}

struct PlaceLookupPage: Hashable {
    let entities: [PlaceLookupEntity]
}
