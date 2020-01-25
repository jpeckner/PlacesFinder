//
//  MeasurementFormatterProtocolMock.swift
//  PlacesFinder
//
//  Created by Justin Peckner.
//  Copyright © 2020 Justin Peckner. All rights reserved.
//

import Foundation
#if DEBUG
@testable import PlacesFinder
#endif

// swiftlint:disable implicitly_unwrapped_optional
internal class MeasurementFormatterProtocolMock: MeasurementFormatterProtocol {

    // MARK: - string<UnitType: Unit>

    internal var stringFromCallsCount = 0
    internal var stringFromCalled: Bool {
        return stringFromCallsCount > 0
    }
    internal var stringFromReturnValue: String!

    internal func string<UnitType: Unit>(from measurement: Measurement<UnitType>) -> String {
        stringFromCallsCount += 1
        return stringFromReturnValue
    }

}
