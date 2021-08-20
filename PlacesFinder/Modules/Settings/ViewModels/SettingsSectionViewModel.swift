//
//  SettingsSectionViewModel.swift
//  PlacesFinder
//
//  Created by Justin Peckner.
//  Copyright © 2019 Justin Peckner. All rights reserved.
//

import Foundation
import Shared
import SwiftDux

struct SettingsSectionViewModel {
    enum HeaderType: Equatable {
        case plain(SettingsPlainHeaderViewModel)
        case measurementSystem(SettingsUnitsHeaderViewModel)
    }

    let headerType: HeaderType
    let cells: [SettingsCellViewModel]
}

extension SettingsSectionViewModel.HeaderType {

    var title: String {
        switch self {
        case let .plain(viewModel):
            return viewModel.title
        case let .measurementSystem(viewModel):
            return viewModel.title
        }
    }

}
