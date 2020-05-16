//
//  Button+AppSkin.swift
//  PlacesFinder
//
//  Created by Justin Peckner.
//  Copyright © 2019 Justin Peckner. All rights reserved.
//

import Shared
import SwiftUI

extension Button {

    func configure(_ textStyleClass: AppTextStyleClass,
                   textColoring: TextColoring) -> some View {
        return
            applyTextLayout(textStyleClass.textLayout)
            .foregroundColor(textColoring.color)
    }

}
