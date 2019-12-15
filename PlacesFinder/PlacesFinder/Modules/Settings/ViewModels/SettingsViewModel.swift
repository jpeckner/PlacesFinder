//
//  SettingsViewModel.swift
//  PlacesFinder
//
//  Created by Justin Peckner.
//  Copyright © 2019 Justin Peckner. All rights reserved.
//

import Foundation
import Shared

@available(iOS 13.0, *)
class SettingsViewModelObservable: ObservableObject {
    @Published var viewModel: SettingsViewModel

    init(viewModel: SettingsViewModel) {
        self._viewModel = Published(initialValue: viewModel)
    }
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
                id: 0,
                title: appCopyContent.settingsHeaders.distanceSectionTitle,
                headerType: .measurementSystem(currentSystemInState: searchPreferencesState.distance.system,
                                               copyContent: appCopyContent.settingsMeasurementSystem),
                cells: searchPreferencesState.distanceCellModels(formatter)
            ),
            SettingsSectionViewModel(
                id: 1,
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
                cellModels: $0.cells.map {
                    .basic(GroupedTableBasicCellViewModel(
                        title: $0.title,
                        image: nil,
                        accessoryType: $0.hasCheckmark ? .checkmark : .none
                    ))
                }
            )
        })
    }

}
