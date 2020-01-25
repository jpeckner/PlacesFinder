//
//  SettingsPresenterProtocol.swift
//  PlacesFinder
//
//  Created by Justin Peckner.
//  Copyright © 2020 Justin Peckner. All rights reserved.
//

import Shared
import UIKit

protocol SettingsPresenterProtocol: AutoMockable {
    var rootNavController: UINavigationController { get }

    func loadSettingsView(_ state: AppState)
}
