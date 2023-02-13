//
//  SettingsViewModel.swift
//  PlacesFinder
//
//  Copyright (c) 2019 Justin Peckner
//  
//  Permission is hereby granted, free of charge, to any person obtaining a copy
//  of this software and associated documentation files (the "Software"), to deal
//  in the Software without restriction, including without limitation the rights
//  to use, copy, modify, merge, publish, distribute, sublicense, and/or sell
//  copies of the Software, and to permit persons to whom the Software is
//  furnished to do so, subject to the following conditions:
//  
//  The above copyright notice and this permission notice shall be included in all
//  copies or substantial portions of the Software.
//  
//  THE SOFTWARE IS PROVIDED "AS IS", WITHOUT WARRANTY OF ANY KIND, EXPRESS OR
//  IMPLIED, INCLUDING BUT NOT LIMITED TO THE WARRANTIES OF MERCHANTABILITY,
//  FITNESS FOR A PARTICULAR PURPOSE AND NONINFRINGEMENT. IN NO EVENT SHALL THE
//  AUTHORS OR COPYRIGHT HOLDERS BE LIABLE FOR ANY CLAIM, DAMAGES OR OTHER
//  LIABILITY, WHETHER IN AN ACTION OF CONTRACT, TORT OR OTHERWISE, ARISING FROM,
//  OUT OF OR IN CONNECTION WITH THE SOFTWARE OR THE USE OR OTHER DEALINGS IN THE
//  SOFTWARE.

import Combine
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

// sourcery: AutoMockable
protocol SettingsViewModelBuilderProtocol {
    func buildViewModel(searchPreferencesState: SearchPreferencesState,
                        appCopyContent: AppCopyContent) -> SettingsViewModel
}

class SettingsViewModelBuilder: SettingsViewModelBuilderProtocol {

    private let actionSubscriber: AnySubscriber<SearchPreferencesAction, Never>
    private let measurementSystemHeaderViewModelBuilder: SettingsUnitsHeaderViewModelBuilderProtocol
    private let plainHeaderViewModelBuilder: SettingsPlainHeaderViewModelBuilderProtocol
    private let settingsCellViewModelBuilder: SettingsCellViewModelBuilderProtocol

    init(actionSubscriber: AnySubscriber<SearchPreferencesAction, Never>,
         measurementSystemHeaderViewModelBuilder: SettingsUnitsHeaderViewModelBuilderProtocol,
         plainHeaderViewModelBuilder: SettingsPlainHeaderViewModelBuilderProtocol,
         settingsCellViewModelBuilder: SettingsCellViewModelBuilderProtocol) {
        self.actionSubscriber = actionSubscriber
        self.measurementSystemHeaderViewModelBuilder = measurementSystemHeaderViewModelBuilder
        self.plainHeaderViewModelBuilder = plainHeaderViewModelBuilder
        self.settingsCellViewModelBuilder = settingsCellViewModelBuilder
    }

    func buildViewModel(searchPreferencesState: SearchPreferencesState,
                        appCopyContent: AppCopyContent) -> SettingsViewModel {
        let sections =
            NonEmptyArray(with:
                SettingsSectionViewModel(
                    headerType: .measurementSystem(
                        measurementSystemHeaderViewModelBuilder.buildViewModel(
                            appCopyContent.settingsHeaders.distanceSectionTitle,
                            currentlyActiveSystem: searchPreferencesState.stored.distance.system,
                            copyContent: appCopyContent.settingsMeasurementSystem
                        )
                    ),
                    cells: settingsCellViewModelBuilder.buildDistanceCellModels(
                        currentDistanceType: searchPreferencesState.stored.distance
                    )
                )
            )
            .appendedWith([
                SettingsSectionViewModel(
                    headerType: .plain(
                        plainHeaderViewModelBuilder.buildViewModel(appCopyContent.settingsHeaders.sortSectionTitle)
                    ),
                    cells: settingsCellViewModelBuilder.buildSortingCellModels(
                        currentSorting: searchPreferencesState.stored.sorting,
                        copyContent: appCopyContent.settingsSortPreference
                    )
                )
            ])
            .appendedWith([
                SettingsSectionViewModel(
                    headerType: .plain(
                        plainHeaderViewModelBuilder.buildViewModel(appCopyContent.settingsChildMenu.sectionTitle)
                    ),
                    cells: [
                        SettingsCellViewModel(
                            title: appCopyContent.settingsChildMenu.ctaTitle,
                            isSelected: false,
                            actionSubscriber: actionSubscriber,
                            action: .showSettingsChild(SettingsChildLinkPayload())
                        )
                    ]
                )
            ])

        return SettingsViewModel(sections: sections)
    }

}
