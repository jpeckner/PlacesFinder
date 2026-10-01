//
//  SearchEntityModel.swift
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

struct SearchEntityModel: Hashable, Sendable {
    let id: NonEmptyString
    let name: NonEmptyString
    let url: URL
    let ratings: SearchRatings?
    let image: URL
    let addressLines: PlaceLookupAddressLines?
    let displayPhone: NonEmptyString?
    let dialablePhone: NonEmptyString?
    let pricing: PlaceLookupPricing?
    let coordinate: PlaceLookupCoordinate?
}

extension SearchEntityModel {

    /// Returns nil if the place is permanently closed, or if it lacks a field that's required for displaying it.
    /// A nil `isPermanentlyClosed` value is treated as the place being open.
    init?(id: NonEmptyString,
          name: NonEmptyString,
          url: URL,
          ratings: SearchRatings?,
          image: URL?,
          addressLines: PlaceLookupAddressLines?,
          displayPhone: NonEmptyString?,
          dialablePhone: NonEmptyString?,
          pricing: PlaceLookupPricing?,
          coordinate: PlaceLookupCoordinate?,
          isPermanentlyClosed: Bool?) {
        guard isPermanentlyClosed != true,
            let image = image
        else {
            return nil
        }

        self.init(id: id,
                  name: name,
                  url: url,
                  ratings: ratings,
                  image: image,
                  addressLines: addressLines,
                  displayPhone: displayPhone,
                  dialablePhone: dialablePhone,
                  pricing: pricing,
                  coordinate: coordinate)
    }

}
