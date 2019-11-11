//
//  UIButton+AppSkin.swift
//  PlacesFinder
//
//  Created by Justin Peckner.
//  Copyright © 2019 Justin Peckner. All rights reserved.
//

import Shared
import SwiftUI
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

@available(iOS 13.0, *)
extension Button {

    func configure(_ textStyleClass: AppTextStyleClass,
                   textColoring: TextColoring) -> some View {
        return
            applyTextLayout(textStyleClass.textLayout)
            .foregroundColor(textColoring.color)
    }

}
