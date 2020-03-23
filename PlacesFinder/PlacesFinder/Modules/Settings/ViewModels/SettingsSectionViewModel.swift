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
    enum HeaderType {
        case plain(SettingsSectionHeaderViewModel)
        case measurementSystem(SettingsMeasurementSystemHeaderViewModel)
    }

    let headerType: HeaderType
    let cells: [SettingsCellViewModel]
}

extension SettingsSectionViewModel {

    var title: String {
        switch headerType {
        case let .plain(viewModel):
            return viewModel.title
        case let .measurementSystem(viewModel):
            return viewModel.title
        }
    }

}
