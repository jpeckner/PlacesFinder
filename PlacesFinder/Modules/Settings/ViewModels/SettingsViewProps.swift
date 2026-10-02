//
//  SettingsViewProps.swift
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

struct SettingsViewProps {
    let sections: NonEmptyArray<SettingsSectionProps>
    let colorings: SettingsViewColorings
}

// MARK: SettingsViewPropsBuilder

// sourcery: AutoMockable
protocol SettingsViewPropsBuilderProtocol {
    func buildProps(searchPreferencesState: SearchPreferencesState,
                    appCopyContent: AppCopyContent,
                    appDisplayName: NonEmptyString,
                    colorings: SettingsViewColorings) -> SettingsViewProps
}

class SettingsViewPropsBuilder: SettingsViewPropsBuilderProtocol {

    private let actionSubscriber: AnySubscriber<SearchPreferencesAction, Never>
    private let measurementSystemHeaderPropsBuilder: SettingsUnitsHeaderPropsBuilderProtocol
    private let plainHeaderPropsBuilder: SettingsPlainHeaderPropsBuilderProtocol
    private let settingsCellPropsBuilder: SettingsCellPropsBuilderProtocol

    init(actionSubscriber: AnySubscriber<SearchPreferencesAction, Never>,
         measurementSystemHeaderPropsBuilder: SettingsUnitsHeaderPropsBuilderProtocol,
         plainHeaderPropsBuilder: SettingsPlainHeaderPropsBuilderProtocol,
         settingsCellPropsBuilder: SettingsCellPropsBuilderProtocol) {
        self.actionSubscriber = actionSubscriber
        self.measurementSystemHeaderPropsBuilder = measurementSystemHeaderPropsBuilder
        self.plainHeaderPropsBuilder = plainHeaderPropsBuilder
        self.settingsCellPropsBuilder = settingsCellPropsBuilder
    }

    func buildProps(searchPreferencesState: SearchPreferencesState,
                    appCopyContent: AppCopyContent,
                    appDisplayName: NonEmptyString,
                    colorings: SettingsViewColorings) -> SettingsViewProps {
        let sections =
            NonEmptyArray(with:
                SettingsSectionProps(
                    id: .searchDistance,
                    headerType: .measurementSystem(
                        measurementSystemHeaderPropsBuilder.buildProps(
                            title: appCopyContent.settingsHeaders.distanceSectionTitle,
                            currentlyActiveSystem: searchPreferencesState.stored.distance.system,
                            copyContent: appCopyContent.settingsMeasurementSystem,
                            colorings: colorings.headerColorings
                        )
                    ),
                    cells: settingsCellPropsBuilder.buildDistanceCellProps(
                        currentDistanceType: searchPreferencesState.stored.distance,
                        colorings: colorings.cellColorings
                    )
                )
            )
            .appendedWith([
                SettingsSectionProps(
                    id: .sortBy,
                    headerType: .plain(
                        plainHeaderPropsBuilder.buildProps(
                            title: appCopyContent.settingsHeaders.sortSectionTitle,
                            colorings: colorings.headerColorings
                        )
                    ),
                    cells: settingsCellPropsBuilder.buildSortingCellProps(
                        currentSorting: searchPreferencesState.stored.sorting,
                        copyContent: appCopyContent.settingsSortPreference,
                        colorings: colorings.cellColorings
                    )
                )
            ])
            .appendedWith([
                SettingsSectionProps(
                    id: .aboutApp,
                    headerType: nil,
                    cells: [
                        SettingsCellProps(
                            title: String(
                                format: appCopyContent.aboutAppMenu.ctaTitleFormat,
                                appDisplayName.value
                            ),
                            isSelected: false,
                            colorings: colorings.cellColorings,
                            actionSubscriber: actionSubscriber,
                            action: .showAboutApp(AboutAppLinkPayload())
                        )
                    ]
                )
            ])

        return SettingsViewProps(
            sections: sections,
            colorings: colorings
        )
    }

}
