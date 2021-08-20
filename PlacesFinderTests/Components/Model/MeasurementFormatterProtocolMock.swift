//
//  MeasurementFormatterProtocolMock.swift
//  PlacesFinderTests
//
//  Created by Justin Peckner.
//  Copyright © 2020 Justin Peckner. All rights reserved.
//

import Foundation

// swiftlint:disable implicitly_unwrapped_optional
internal class MeasurementFormatterProtocolMock: MeasurementFormatterProtocol {

    // MARK: - string<UnitType: Unit>

    internal var stringFromCallsCount = 0
    internal var stringFromCalled: Bool {
        return stringFromCallsCount > 0
    }
    internal var stringFromReceivedMeasurement: Any?
    internal var stringFromReturnValue: String!
    internal var stringFromClosure: ((Any) -> String)?

    internal func string<UnitType: Unit>(from measurement: Measurement<UnitType>) -> String {
        stringFromCallsCount += 1
        stringFromReceivedMeasurement = measurement
        return stringFromClosure.map { $0(measurement) } ?? stringFromReturnValue
    }

}
