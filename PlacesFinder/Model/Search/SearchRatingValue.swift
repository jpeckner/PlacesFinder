//
//  SearchRatingValue.swift
//  PlacesFinder
//
//  Created by Justin Peckner.
//  Copyright © 2019 Justin Peckner. All rights reserved.
//

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
