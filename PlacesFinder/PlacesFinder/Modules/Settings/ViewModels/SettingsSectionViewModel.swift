//
//  SettingsSectionViewModel.swift
//  PlacesFinder
//
//  Created by Justin Peckner.
//  Copyright © 2019 Justin Peckner. All rights reserved.
//

import Foundation
import Shared
import SwiftDux

struct SettingsSectionViewModel {
    enum HeaderType {
        case plain(SettingsSectionHeaderViewModel)
        case measurementSystem(SettingsMeasurementSystemHeaderViewModel)
    }

    let headerType: HeaderType
    let cells: [SettingsCellViewModel]
}

extension SettingsSectionViewModel {

    var title: String {
        switch headerType {
        case let .plain(viewModel):
            return viewModel.title
        case let .measurementSystem(viewModel):
            return viewModel.title
        }
    }

}

struct SettingsSectionHeaderViewModel {
    let title: String
}

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
