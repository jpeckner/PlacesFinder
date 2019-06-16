//
//  UILabel+AppSkin.swift
//  PlacesFinder
//
//  Created by Justin Peckner.
//  Copyright © 2018 Justin Peckner. All rights reserved.
//

import Shared
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
