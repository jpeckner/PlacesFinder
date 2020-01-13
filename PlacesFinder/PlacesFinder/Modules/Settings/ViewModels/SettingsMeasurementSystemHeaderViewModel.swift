//
//  SettingsMeasurementSystemHeaderViewModel.swift
//  PlacesFinder
//
//  Created by Justin Peckner.
//  Copyright © 2020 Justin Peckner. All rights reserved.
//

import Foundation
import Shared
import SwiftDux

struct SettingsMeasurementSystemHeaderViewModel {
    enum SystemOption {
        case selectable(title: String, selectionAction: Action)
        case nonSelectable(title: String)
    }

    let title: String
    let systemOptions: [SystemOption]
}

extension SettingsMeasurementSystemHeaderViewModel {

    init(title: String,
         currentlyActiveSystem: MeasurementSystem,
         copyContent: SettingsMeasurementSystemCopyContent) {
        self.title = title
        self.systemOptions = MeasurementSystem.allCases.map {
            let systemTitle = copyContent.title($0)
            return $0 == currentlyActiveSystem ?
                .nonSelectable(title: systemTitle)
                : .selectable(
                    title: systemTitle,
                    selectionAction: SearchPreferencesActionCreator.setMeasurementSystem($0)
                )
        }
    }

}

private extension SettingsMeasurementSystemCopyContent {

    func title(_ measurementSystem: MeasurementSystem) -> String {
        switch measurementSystem {
        case .imperial:
            return imperial
        case .metric:
            return metric
        }
    }

}
