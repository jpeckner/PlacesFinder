//
//  APILogoConstants.swift
//  PlacesFinder
//
//  Created by Justin Peckner.
//  Copyright © 2019 Justin Peckner. All rights reserved.
//

import UIKit

enum APILogoConstants {
    // Per https://www.yelp.com/brand#content - "If you need to display the Yelp logo on a white background be sure
    // to use the version with the grey stroke."
    static let logoImage = #imageLiteral(resourceName: "Yelp_trademark_RGB_dynamic")

    // Per https://www.yelp.com/brand#content - "We require that our logo be shown no smaller than...64dp in width
    // for screens."
    static let minWidth: CGFloat = 64.0
}
