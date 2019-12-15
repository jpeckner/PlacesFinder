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

struct SettingsCellViewModel: Hashable {
    let title: String
    let hasCheckmark: Bool
    let action: IgnoredHashable<Action>
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

extension SettingsSectionViewModel: Identifiable {

    var id: String {
        return title
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

@available(iOS 13.0, *)
class SettingsViewModelObservable: ObservableObject {
    @Published var viewModel: SettingsViewModel

    init(viewModel: SettingsViewModel) {
        self._viewModel = Published(initialValue: viewModel)
    }
}
