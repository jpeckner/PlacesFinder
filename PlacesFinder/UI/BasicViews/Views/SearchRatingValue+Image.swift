//
//  SearchRatingValue+Image.swift
//  PlacesFinder
//
//  Created by Justin Peckner.
//  Copyright © 2020 Justin Peckner. All rights reserved.
//

import UIKit

extension SearchRatingValue {

    var starsImage: UIImage {
        switch self {
        case .one:
            return #imageLiteral(resourceName: "extra_large_1")
        case .oneAndAHalf:
            return #imageLiteral(resourceName: "extra_large_1_half")
        case .two:
            return #imageLiteral(resourceName: "extra_large_2")
        case .twoAndAHalf:
            return #imageLiteral(resourceName: "extra_large_2_half")
        case .three:
            return #imageLiteral(resourceName: "extra_large_3")
        case .threeAndAHalf:
            return #imageLiteral(resourceName: "extra_large_3_half")
        case .four:
            return #imageLiteral(resourceName: "extra_large_4")
        case .fourAndAHalf:
            return #imageLiteral(resourceName: "extra_large_4_half")
        case .five:
            return #imageLiteral(resourceName: "extra_large_5")
        }
    }

}
