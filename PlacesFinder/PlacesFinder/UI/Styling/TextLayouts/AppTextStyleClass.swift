//
//  AppTextStyleClass.swift
//  PlacesFinder
//
//  Created by Justin Peckner.
//  Copyright © 2018 Justin Peckner. All rights reserved.
//

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
