//
//  UILabel+AppSkin.swift
//  PlacesFinder
//
//  Created by Justin Peckner.
//  Copyright © 2018 Justin Peckner. All rights reserved.
//

import Shared
import SwiftUI
import UIKit

extension StyledLabel {

    convenience init(textStyleClass: AppTextStyleClass,
                     textColoring: TextColoring,
                     numberOfLines: Int = 0) {
        self.init(textLayout: textStyleClass.textLayout,
                  textColoring: textColoring,
                  numberOfLines: numberOfLines)
    }

}

extension UILabel {

    func configure(_ textStyleClass: AppTextStyleClass,
                   textColoring: TextColoring) {
        applyTextLayout(textStyleClass.textLayout)
        applyTextColoring(textColoring)
    }

}

// MARK: StyledLabelSUI

@available(iOS 13.0, *)
extension StyledLabelSUI {

    init(text: String,
         styleClass: AppTextStyleClass,
         textColoring: TextColoring = .init(textColor: .label),
         numberOfLines: Int? = nil) {
        self.init(text: text,
                  font: Font(styleClass.textLayout.font.ctFont),
                  alignment: styleClass.textLayout.alignment.textAlignment,
                  textColoring: textColoring,
                  numberOfLines: numberOfLines)
    }

}

@available(iOS 13.0, *)
extension Text {

    func configure(_ textStyleClass: AppTextStyleClass,
                   textColoring: TextColoring) -> some View {
        var configuredText = self
        configuredText = configuredText.foregroundColor(textColoring.color)
        return configuredText.applyTextLayout(textStyleClass.textLayout)
    }

}
