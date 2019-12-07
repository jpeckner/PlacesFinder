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

    static let widthToHeightRatio: CGFloat = #imageLiteral(resourceName: "Yelp_trademark_RGB").widthToHeightRatio
    static let minWidth: CGFloat = 64.0

    init(viewColoring: ViewColoring) {
        let apiLogo = viewColoring.apiLogo

        super.init(image: apiLogo)

        // Per https://www.yelp.com/brand#content - "We require that our logo be shown no smaller than...64dp in width
        // for screens."
        widthAnchor.constraint(greaterThanOrEqualToConstant: APILogoView.minWidth).isActive = true
        alignProportions(with: apiLogo)
    }

    required init?(coder aDecoder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }

}

extension ViewColoring {

    var apiLogo: UIImage {
        if #available(iOS 13.0.0, *) {
            return #imageLiteral(resourceName: "Yelp_trademark_RGB_dynamic")
        }

        // Per https://www.yelp.com/brand#content - "If you need to display the Yelp logo on a white background be sure
        // to use the version with the grey stroke."
        let colorComponents = backgroundColor.colorComponents
        let isEqualOrCloseToWhite =
            colorComponents.red >= 0.95
            && colorComponents.green >= 0.95
            && colorComponents.blue >= 0.95
        return isEqualOrCloseToWhite ? #imageLiteral(resourceName: "Yelp_trademark_RGB_outline") : #imageLiteral(resourceName: "Yelp_trademark_RGB")
    }

}
