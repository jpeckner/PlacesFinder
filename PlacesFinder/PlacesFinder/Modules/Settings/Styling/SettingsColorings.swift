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
    let activeButtonTextColoring: TextColoring
    let cellTextColoring: TextColoring
    let cellCheckmarkTint: FillColoring
    let headerTextColoring: TextColoring
}
