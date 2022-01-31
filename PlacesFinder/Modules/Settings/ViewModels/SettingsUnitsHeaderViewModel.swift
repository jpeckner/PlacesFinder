//
//  SettingsUnitsHeaderViewModel.swift
//  PlacesFinder
//
//  Copyright (c) 2020 Justin Peckner
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
    func buildViewModel(_ title: String,
                        currentlyActiveSystem: MeasurementSystem,
                        copyContent: SettingsMeasurementSystemCopyContent) -> SettingsUnitsHeaderViewModel
}

class SettingsUnitsHeaderViewModelBuilder: SettingsUnitsHeaderViewModelBuilderProtocol {

    private let actionSubscriber: AnySubscriber<Action, Never>

    init(actionSubscriber: AnySubscriber<Action, Never>) {
        self.actionSubscriber = actionSubscriber
    }

    func buildViewModel(_ title: String,
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
                        selectionAction: IgnoredEquatable { [weak self] in
                            let action = SearchPreferencesActionCreator.setMeasurementSystem(system)
                            _ = self?.actionSubscriber.receive(action)
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
