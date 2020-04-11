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

    var tableModel: GroupedTableViewModel {
        return GroupedTableViewModel(sectionModels: sections.value.map {
            GroupedTableViewSectionModel(
                title: $0.headerType.title,
                cellModels: $0.cells.map {
                    .basic(GroupedTableBasicCellViewModel(title: $0.title,
                                                          image: nil,
                                                          accessoryType: $0.isSelected ? .checkmark : .none))
                }
            )
        })
    }

}

// MARK: SettingsViewModelBuilder

protocol SettingsViewModelBuilderProtocol: AutoMockable {
    func buildViewModel(searchPreferencesState: SearchPreferencesState,
                        appCopyContent: AppCopyContent) -> SettingsViewModel
}

class SettingsViewModelBuilder: SettingsViewModelBuilderProtocol {

    private let store: DispatchingStoreProtocol
    private let measurementSystemHeaderViewModelBuilder: SettingsUnitsHeaderViewModelBuilderProtocol
    private let plainHeaderViewModelBuilder: SettingsPlainHeaderViewModelBuilderProtocol
    private let settingsCellViewModelBuilder: SettingsCellViewModelBuilderProtocol

    init(store: DispatchingStoreProtocol,
         measurementSystemHeaderViewModelBuilder: SettingsUnitsHeaderViewModelBuilderProtocol,
         plainHeaderViewModelBuilder: SettingsPlainHeaderViewModelBuilderProtocol,
         settingsCellViewModelBuilder: SettingsCellViewModelBuilderProtocol) {
        self.store = store
        self.measurementSystemHeaderViewModelBuilder = measurementSystemHeaderViewModelBuilder
        self.plainHeaderViewModelBuilder = plainHeaderViewModelBuilder
        self.settingsCellViewModelBuilder = settingsCellViewModelBuilder
    }

    func buildViewModel(searchPreferencesState: SearchPreferencesState,
                        appCopyContent: AppCopyContent) -> SettingsViewModel {
        let sections =
            NonEmptyArray(with:
                SettingsSectionViewModel(
                    id: 0,
                    headerType: .measurementSystem(
                        measurementSystemHeaderViewModelBuilder.buildViewModel(
                            store,
                            title: appCopyContent.settingsHeaders.distanceSectionTitle,
                            currentlyActiveSystem: searchPreferencesState.distance.system,
                            copyContent: appCopyContent.settingsMeasurementSystem
                        )
                    ),
                    cells: settingsCellViewModelBuilder.buildDistanceCellModels(searchPreferencesState.distance)
                )
            ).appendedWith([
                SettingsSectionViewModel(
                    id: 1,
                    headerType: .plain(
                        plainHeaderViewModelBuilder.buildViewModel(appCopyContent.settingsHeaders.sortSectionTitle)
                    ),
                    cells: settingsCellViewModelBuilder.buildSortingCellModels(
                        searchPreferencesState.sorting,
                        copyContent: appCopyContent.settingsSortPreference
                    )
                )
            ])

        return SettingsViewModel(sections: sections)
    }

}
