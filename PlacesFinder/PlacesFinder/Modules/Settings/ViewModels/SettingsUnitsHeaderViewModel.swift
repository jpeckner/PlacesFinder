//
//  SettingsUnitsHeaderViewModel.swift
//  PlacesFinder
//
//  Created by Justin Peckner.
//  Copyright © 2020 Justin Peckner. All rights reserved.
//

import Foundation
import Shared
import SwiftDux

struct SettingsUnitsHeaderViewModel: Equatable {
    enum SystemOption: Equatable {
        case selectable(title: String, selectionAction: IgnoredEquatable<() -> Void>)
        case nonSelectable(title: String)
    }

    let title: String
    let systemOptions: [SystemOption]
}

// MARK: SettingsUnitsHeaderViewModelBuilder

protocol SettingsUnitsHeaderViewModelBuilderProtocol: AutoMockable {
    func buildViewModel(_ store: DispatchingStoreProtocol,
                        title: String,
                        currentlyActiveSystem: MeasurementSystem,
                        copyContent: SettingsMeasurementSystemCopyContent) -> SettingsUnitsHeaderViewModel
}

class SettingsUnitsHeaderViewModelBuilder: SettingsUnitsHeaderViewModelBuilderProtocol {

    func buildViewModel(_ store: DispatchingStoreProtocol,
                        title: String,
                        currentlyActiveSystem: MeasurementSystem,
                        copyContent: SettingsMeasurementSystemCopyContent) -> SettingsUnitsHeaderViewModel {
        let systemOptions: [SettingsUnitsHeaderViewModel.SystemOption] =
            MeasurementSystem.allCases.map { system in
                let systemTitle = copyContent.title(system)
                return system == currentlyActiveSystem ?
                    .nonSelectable(title: systemTitle)
                    :
                    .selectable(
                        title: systemTitle,
                        selectionAction: IgnoredEquatable {
                            store.dispatch(SearchPreferencesActionCreator.setMeasurementSystem(system))
                        }
                    )
            }

        return SettingsUnitsHeaderViewModel(title: title,
                                            systemOptions: systemOptions)
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
