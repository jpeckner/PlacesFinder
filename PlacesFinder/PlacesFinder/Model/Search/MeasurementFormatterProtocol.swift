//
//  MeasurementFormatterProtocol.swift
//  PlacesFinder
//
//  Created by Justin Peckner.
//  Copyright © 2020 Justin Peckner. All rights reserved.
//

import Foundation
import Shared

protocol MeasurementFormatterProtocol {
    func string<UnitType: Unit>(from measurement: Measurement<UnitType>) -> String
}

extension MeasurementFormatter: MeasurementFormatterProtocol {}
