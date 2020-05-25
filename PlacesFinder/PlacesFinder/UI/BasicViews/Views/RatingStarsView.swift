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
