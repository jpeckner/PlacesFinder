//
//  LocationAuthAction.swift
//  PlacesFinder
//
//  Created by Justin Peckner.
//  Copyright © 2018 Justin Peckner. All rights reserved.
//

import Foundation
import Shared
import SwiftDux

enum LocationAuthAction: Action {
    case notDetermined
    case locationServicesEnabled
    case locationServicesDisabled
}
