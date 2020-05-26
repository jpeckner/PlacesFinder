//
//  StyledText+AppSkin.swift
//  PlacesFinder
//
//  Created by Justin Peckner.
//  Copyright © 2019 Justin Peckner. All rights reserved.
//

import Shared
import SwiftUI

extension StyledText {

    init(text: String,
         styleClass: AppTextStyleClass,
         textColoring: TextColoring) {
        self.init(text: text,
                  font: Font(styleClass.textLayout.font.ctFont),
                  alignment: styleClass.textLayout.alignment.textAlignment,
                  textColoring: textColoring)
    }

}
