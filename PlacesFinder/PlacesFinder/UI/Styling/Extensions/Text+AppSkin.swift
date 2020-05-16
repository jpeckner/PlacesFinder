//
//  Text+AppSkin.swift
//  PlacesFinder
//
//  Created by Justin Peckner.
//  Copyright © 2019 Justin Peckner. All rights reserved.
//

import Shared
import SwiftUI

extension Text {

    func configure(_ textStyleClass: AppTextStyleClass,
                   textColoring: TextColoring) -> some View {
        var configuredText = self
        configuredText = configuredText.foregroundColor(textColoring.color)
        return configuredText.applyTextLayout(textStyleClass.textLayout)
    }

}
