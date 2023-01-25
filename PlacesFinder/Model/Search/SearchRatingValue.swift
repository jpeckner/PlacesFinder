//
//  SearchRatingValue.swift
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

struct SearchRatings: Equatable {
    let average: SearchRatingValue
    let numRatings: Int
}

// Per https://www.yelp.com/developers/documentation/v3/business_search - "value ranges from 1, 1.5, ... 4.5, 5"
enum SearchRatingValue: Double {
    static let maxRating: Double = 5.0

    case one = 1.0
    case oneAndAHalf = 1.5
    case two = 2.0
    case twoAndAHalf = 2.5
    case three = 3.0
    case threeAndAHalf = 3.5
    case four = 4.0
    case fourAndAHalf = 4.5
    case five = 5.0
}

extension SearchRatingValue {

    init?(averageRating: Percentage) {
        switch averageRating.value * SearchRatingValue.maxRating {
        case 1.0:
            self = .one
        case 1.5:
            self = .oneAndAHalf
        case 2.0:
            self = .two
        case 2.5:
            self = .twoAndAHalf
        case 3.0:
            self = .three
        case 3.5:
            self = .threeAndAHalf
        case 4.0:
            self = .four
        case 4.5:
            self = .fourAndAHalf
        case 5.0:
            self = .five
        default:
            return nil
        }
    }

}
