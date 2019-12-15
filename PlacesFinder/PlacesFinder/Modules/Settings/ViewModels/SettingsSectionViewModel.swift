//
//  SettingsSectionViewModel.swift
//  PlacesFinder
//
//  Created by Justin Peckner.
//  Copyright © 2019 Justin Peckner. All rights reserved.
//

import Foundation
import Shared

struct SettingsSectionViewModel: Identifiable {
    enum HeaderType {
        case plain

        case measurementSystem(
            currentSystemInState: MeasurementSystem,
            copyContent: SettingsMeasurementSystemCopyContent
        )
    }

    let id: Int

    let title: String
    let headerType: HeaderType
    let cells: [SettingsCellViewModel]
}
