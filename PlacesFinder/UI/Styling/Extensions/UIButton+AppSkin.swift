//
//  UIButton+AppSkin.swift
//  PlacesFinder
//
//  Created by Justin Peckner.
//  Copyright © 2019 Justin Peckner. All rights reserved.
//

import Shared
import UIKit

extension UIButton {

    func configure(_ textStyleClass: AppTextStyleClass,
                   textColoring: TextColoring) {
        applyTextStyle(textStyleClass)
        applyTextColoring(textColoring)
    }

    func applyTextStyle(_ textStyleClass: AppTextStyleClass) {
        applyTextLayout(textStyleClass.textLayout)
    }

}
