//
//  LaunchViewProtocol.swift
//  PlacesFinder
//
//  Created by Justin Peckner.
//  Copyright © 2019 Justin Peckner. All rights reserved.
//

import Shared
import UIKit

protocol LaunchViewProtocol {
    func startSpinner()
    func animateOut(_ completion: (() -> Void)?)
}

// sourcery: fieldName = "launch"
struct LaunchViewColorings: AppColoringProtocol {
    let viewColoring: ViewColoring
    let spinnerColor: FillColoring
}
