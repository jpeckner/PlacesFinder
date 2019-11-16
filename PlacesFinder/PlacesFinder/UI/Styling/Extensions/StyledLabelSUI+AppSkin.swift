//
//  StyledLabelSUI+AppSkin.swift
//  PlacesFinder
//
//  Created by Justin Peckner.
//  Copyright © 2019 Justin Peckner. All rights reserved.
//

import Shared
import SwiftUI

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
