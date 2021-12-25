//
//  SearchDistance.swift
//  PlacesFinder
//
//  Created by Justin Peckner.
//  Copyright © 2019 Justin Peckner. All rights reserved.
//

import Foundation
import Shared

protocol SearchDistanceTypeProtocol {
    var measurement: Measurement<UnitLength> { get }
}

enum SearchDistance: Equatable, AutoCodable {
    case imperial(SearchDistanceImperial)
    case metric(SearchDistanceMetric)
}

extension SearchDistance {

    var system: MeasurementSystem {
        switch self {
        case .imperial:
            return .imperial
        case .metric:
            return .metric
        }
    }

    var distanceType: SearchDistanceTypeProtocol {
        switch self {
        case let .imperial(distance):
            return distance
        case let .metric(distance):
            return distance
        }
    }

}

enum SearchDistanceImperial: CaseIterable, AutoCodable {
    case oneMile
    case fiveMiles
    case tenMiles
    case twentyMiles
}

extension SearchDistanceImperial: SearchDistanceTypeProtocol {

    static var defaultDistance: SearchDistanceImperial {
        return .tenMiles
    }

    var measurement: Measurement<UnitLength> {
        switch self {
        case .oneMile:
            return Measurement(value: 1.0, unit: .miles)
        case .fiveMiles:
            return Measurement(value: 5.0, unit: .miles)
        case .tenMiles:
            return Measurement(value: 10.0, unit: .miles)
        case .twentyMiles:
            return Measurement(value: 20.0, unit: .miles)
        }
    }

}

enum SearchDistanceMetric: CaseIterable, AutoCodable {
    case fiveKilometers
    case tenKilometers
    case twentyKilometers
    case fortyKilometers
}

extension SearchDistanceMetric: SearchDistanceTypeProtocol {

    static var defaultDistance: SearchDistanceMetric {
        return .twentyKilometers
    }

    var measurement: Measurement<UnitLength> {
        switch self {
        case .fiveKilometers:
            return Measurement(value: 5.0, unit: .kilometers)
        case .tenKilometers:
            return Measurement(value: 10.0, unit: .kilometers)
        case .twentyKilometers:
            return Measurement(value: 20.0, unit: .kilometers)
        case .fortyKilometers:
            return Measurement(value: 40.0, unit: .kilometers)
        }
    }

}
