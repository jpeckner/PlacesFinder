//
//  SettingsViewModel+Stub.swift
//  PlacesFinder
//
//  Created by Justin Peckner.
//  Copyright © 2020 Justin Peckner. All rights reserved.
//

import Foundation

extension SettingsSectionViewModel {

    static func stubValue(headerType: SettingsSectionViewModel.HeaderType = .plain(.stubValue()),
                          cells: [SettingsCellViewModel] = []) -> SettingsSectionViewModel {
        return SettingsSectionViewModel(headerType: headerType,
                                        cells: cells)
    }

}

extension SettingsPlainHeaderViewModel {

    static func stubValue(title: String = "stubTitle") -> SettingsPlainHeaderViewModel {
        return SettingsPlainHeaderViewModel(title: title)
    }

}

extension SettingsUnitsHeaderViewModel {

    static func stubValue(
        title: String = "stubUnitsHeaderTitle",
        systemOptions: [SettingsUnitsHeaderViewModel.SystemOption] = []
    ) -> SettingsUnitsHeaderViewModel {
        return SettingsUnitsHeaderViewModel(title: title,
                                            systemOptions: systemOptions)
    }

}
