//
//  RatingStarsView.swift
//  PlacesFinder
//
//  Created by Justin Peckner.
//  Copyright © 2019 Justin Peckner. All rights reserved.
//

import Shared
import UIKit

class RatingStarsView: UIImageView {

    private static let placeholderImage = #imageLiteral(resourceName: "extra_large_0")

    init() {
        super.init(image: RatingStarsView.placeholderImage)

        alignProportions(with: RatingStarsView.placeholderImage)
        heightAnchor.constraint(equalToConstant: 30.0).isActive = true
    }

    required init?(coder aDecoder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }

    func configure(_ rating: SearchRatingValue) {
        image = rating.starsImage
    }

}

private extension SearchRatingValue {

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
