//
//  APILogoView.swift
//  PlacesFinder
//
//  Created by Justin Peckner.
//  Copyright © 2019 Justin Peckner. All rights reserved.
//

import Shared
import UIKit

class APILogoView: UIImageView {

    init(viewColoring: ViewColoring) {
        super.init(image: APILogoConstants.logoImage)

        widthAnchor.constraint(greaterThanOrEqualToConstant: APILogoConstants.minWidth).isActive = true
        alignProportions(with: APILogoConstants.logoImage)
    }

    required init?(coder aDecoder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }

}
