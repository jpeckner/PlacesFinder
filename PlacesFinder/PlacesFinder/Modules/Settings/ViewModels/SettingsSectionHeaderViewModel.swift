//
//  SettingsSectionHeaderViewModel.swift
//  PlacesFinder
//
//  Created by Justin Peckner.
//  Copyright © 2020 Justin Peckner. All rights reserved.
//

import Shared
import SwiftDux

struct SettingsSectionHeaderViewModel {
    let title: String
}

struct SettingsMeasurementSystemHeaderViewModel {
    enum SystemOption {
        case selectable(title: String, selectionAction: () -> Void)
        case nonSelectable(title: String)
    }

    let title: String
    let systemOptions: [SystemOption]
}

extension SettingsMeasurementSystemHeaderViewModel {

    init(title: String,
         currentlyActiveSystem: MeasurementSystem,
         store: DispatchingStoreProtocol,
         copyContent: SettingsMeasurementSystemCopyContent) {
        self.title = title
        self.systemOptions = MeasurementSystem.allCases.map { system in
            let systemTitle = copyContent.title(system)
            return system == currentlyActiveSystem ?
                .nonSelectable(title: systemTitle)
                :
                .selectable(
                    title: systemTitle,
                    selectionAction: {
                        store.dispatch(SearchPreferencesActionCreator.setMeasurementSystem(system))
                    }
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
