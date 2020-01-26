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

struct SettingsViewModel {
    let sections: NonEmptyArray<SettingsSectionViewModel>
}

extension SettingsViewModel {

    init(searchPreferencesState: SearchPreferencesState,
         measurementFormatter: MeasurementFormatterProtocol,
         appCopyContent: AppCopyContent) {
        self.sections =
            NonEmptyArray(with:
                SettingsSectionViewModel(
                    headerType: .measurementSystem(
                        SettingsMeasurementSystemHeaderViewModel(
                            title: appCopyContent.settingsHeaders.distanceSectionTitle,
                            currentlyActiveSystem: searchPreferencesState.distance.system,
                            copyContent: appCopyContent.settingsMeasurementSystem
                        )
                    ),
                    cells: searchPreferencesState.distanceCellModels(measurementFormatter)
                )
            ).appendedWith([
                SettingsSectionViewModel(
                    headerType: .plain(
                        SettingsSectionHeaderViewModel(title: appCopyContent.settingsHeaders.sortSectionTitle)
                    ),
                    cells: searchPreferencesState.sortingCellModels(appCopyContent.settingsSortPreference)
                ),
            ])
    }

    var tableModel: GroupedTableViewModel {
        return GroupedTableViewModel(sectionModels: sections.value.map {
            GroupedTableViewSectionModel(
                title: $0.title,
                cellModels: $0.cells.map { $0.cellModel }
            )
        })
    }

}
