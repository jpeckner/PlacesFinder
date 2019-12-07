//
//  ViewColoring+APILogo.swift
//  PlacesFinder
//
//  Created by Justin Peckner.
//  Copyright © 2019 Justin Peckner. All rights reserved.
//

import Shared
import UIKit

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
