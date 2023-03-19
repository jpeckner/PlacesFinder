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
import SwiftUI
import UIKit

struct APILogoView: View {

    // Per https://www.yelp.com/brand#content - "We require that our logo be shown no smaller than...64dp in width
    // for screens."
    static let minWidth: CGFloat = 64.0
    static let widthToHeightRatio: CGFloat = #imageLiteral(resourceName: "Yelp_trademark_RGB").widthToHeightRatio

    private let viewColoring: ViewColoring
    private let additionalWidth: CGFloat

    init(viewColoring: ViewColoring,
         additionalWidth: CGFloat = .zero) {
        self.viewColoring = viewColoring
        self.additionalWidth = additionalWidth
    }

    var body: some View {
        Image(uiImage: viewColoring.apiLogo)
            .resizable()
            .aspectRatio(contentMode: .fit)
            .frame(width: APILogoView.minWidth + additionalWidth)
    }

}

extension ViewColoring {

    var apiLogo: UIImage { #imageLiteral(resourceName: "Yelp_trademark_RGB_dynamic") }

}
