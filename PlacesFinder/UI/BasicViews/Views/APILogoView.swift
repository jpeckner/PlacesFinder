//
//  APILogoView.swift
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
