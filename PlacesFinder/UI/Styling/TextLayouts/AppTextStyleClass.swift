//
//  AppTextStyleClass.swift
//  PlacesFinder
//
//  Copyright (c) 2018 Justin Peckner
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

enum AppTextStyleClass {
    case body
    case cellText
    case ctaButton
    case navBarTitle
    case pricingLabel
    case sourceAPILabel
    case subtitle
    case tableHeader
    case tableHeaderNonSelectableOption
    case tableHeaderSelectableOption
    case textInput
    case title
}

extension AppTextStyleClass {

    private enum FontDescriptorPalette {
        static let light = UIFontDescriptor(fontAttributes: [.family: "Avenir", .face: "Light"])
        static let lightOblique = UIFontDescriptor(fontAttributes: [.family: "Avenir", .face: "Oblique"])
        static let black = UIFontDescriptor(fontAttributes: [.family: "Avenir", .face: "Black"])
    }

    // Each view in the app can use its own custom TextLayout values if needed, but in practice, I've found that
    // development is faster, easier, and more bug-free when the design and front-end teams agree on a simple set of
    // universal text layouts like these. -JP
    var textLayout: TextLayout {
        switch self {
        case .body:
            return TextLayout(
                font: UIFont(descriptor: FontDescriptorPalette.light, size: 20.0),
                alignment: .center
            )
        case .cellText:
            return TextLayout(
                font: UIFont(descriptor: FontDescriptorPalette.light, size: 16.0),
                alignment: .left
            )
        case .ctaButton:
            return TextLayout(
                font: UIFont(descriptor: FontDescriptorPalette.light, size: 18.0),
                alignment: .center
            )
        case .navBarTitle:
            return TextLayout(
                font: UIFont(descriptor: FontDescriptorPalette.light, size: 24.0),
                alignment: .center
            )
        case .pricingLabel:
            return TextLayout(
                font: UIFont(descriptor: FontDescriptorPalette.light, size: 22.0),
                alignment: .right
            )
        case .sourceAPILabel:
            return TextLayout(
                font: UIFont(descriptor: FontDescriptorPalette.lightOblique, size: 16.0),
                alignment: .center
            )
        case .subtitle:
            return TextLayout(
                font: UIFont(descriptor: FontDescriptorPalette.black, size: 32.0),
                alignment: .center
            )
        case .tableHeader:
            return TextLayout(
                font: UIFont(descriptor: FontDescriptorPalette.black, size: 12.0),
                alignment: .left
            )
        case .tableHeaderNonSelectableOption:
            return TextLayout(
                font: UIFont(descriptor: FontDescriptorPalette.black, size: 12.0),
                alignment: .center
            )
        case .tableHeaderSelectableOption:
            return TextLayout(
                font: UIFont(descriptor: FontDescriptorPalette.light, size: 12.0),
                alignment: .center
            )
        case .textInput:
            return TextLayout(
                font: UIFont(descriptor: FontDescriptorPalette.black, size: 16.0),
                alignment: .left
            )
        case .title:
            return TextLayout(
                font: UIFont(descriptor: FontDescriptorPalette.black, size: 48.0),
                alignment: .center
            )
        }
    }

}
