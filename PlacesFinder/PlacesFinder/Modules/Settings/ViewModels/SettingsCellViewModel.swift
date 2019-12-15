//
//  SettingsCellViewModel.swift
//  PlacesFinder
//
//  Created by Justin Peckner.
//  Copyright © 2019 Justin Peckner. All rights reserved.
//

import Foundation
import Shared
import SwiftDux

struct SettingsCellViewModel: Identifiable {
    let id: Int

    let title: String
    let hasCheckmark: Bool
    let action: Action
}
