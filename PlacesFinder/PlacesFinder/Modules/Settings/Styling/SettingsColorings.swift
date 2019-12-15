// swiftlint:disable:this file_name
//
//  SettingsColorings.swift
//  PlacesFinder
//
//  Created by Justin Peckner.
//  Copyright © 2019 Justin Peckner. All rights reserved.
//

import Shared

// sourcery: fieldName = "settings"
struct SettingsViewColorings: AppColoringProtocol {
    let viewColoring: ViewColoring
    let cellColorings: SettingsCellColorings
    let headerColorings: SettingsHeaderViewColorings
}

struct SettingsCellColorings: Decodable, Equatable {
    let textColoring: TextColoring
    let checkmarkTint: FillColoring
}

struct SettingsHeaderViewColorings: Decodable, Equatable {
    let textColoring: TextColoring
    let activeButtonTextColoring: TextColoring
}
