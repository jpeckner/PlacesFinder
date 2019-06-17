//
//  SettingsViewModel.swift
//  PlacesFinder
//
//  Created by Justin Peckner.
//  Copyright © 2019 Justin Peckner. All rights reserved.
//

import Foundation
import Shared
import SwiftDux

struct SettingsCellViewModel {
    let cellModel: GroupedTableViewCellModel
    let action: Action
}

struct SettingsSectionViewModel {
    enum HeaderType {
        case plain

        case measurementSystem(
            currentSystemInState: MeasurementSystem,
            copyContent: SettingsMeasurementSystemCopyContent
        )
    }

    let title: String
    let headerType: HeaderType
    let cells: [SettingsCellViewModel]
}

struct SettingsViewModel {
    let sections: [SettingsSectionViewModel]
}

extension SettingsViewModel {

    init(searchPreferencesState: SearchPreferencesState,
         formatter: MeasurementFormatter,
         appCopyContent: AppCopyContent) {
        self.sections = [
            SettingsSectionViewModel(
                title: appCopyContent.settingsHeaders.distanceSectionTitle,
                headerType: .measurementSystem(currentSystemInState: searchPreferencesState.distance.system,
                                               copyContent: appCopyContent.settingsMeasurementSystem),
                cells: searchPreferencesState.distanceCellModels(formatter)
            ),
            SettingsSectionViewModel(
                title: appCopyContent.settingsHeaders.sortSectionTitle,
                headerType: .plain,
                cells: searchPreferencesState.sortingCellModels(appCopyContent.settingsSortPreference)
            ),
        ]
    }

    var tableModel: GroupedTableViewModel {
        return GroupedTableViewModel(sectionModels: sections.map {
            GroupedTableViewSectionModel(
                title: $0.title,
                cellModels: $0.cells.map { $0.cellModel }
            )
        })
    }

}
