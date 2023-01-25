//
//  SearchDistance.swift
//  PlacesFinder
//
//  Copyright (c) 2019 Justin Peckner
//  
//  Permission is hereby granted, free of charge, to any person obtaining a copy
//  of this software and associated documentation files (the "Software"), to deal
//  in the Software without restriction, including without limitation the rights
//  to use, copy, modify, merge, publish, distribute, sublicense, and/or sell
//  copies of the Software, and to permit persons to whom the Software is
//  furnished to do so, subject to the following conditions:
//  
//  The above copyright notice and this permission notice shall be included in all
//  copies or substantial portions of the Software.
//  
//  THE SOFTWARE IS PROVIDED "AS IS", WITHOUT WARRANTY OF ANY KIND, EXPRESS OR
//  IMPLIED, INCLUDING BUT NOT LIMITED TO THE WARRANTIES OF MERCHANTABILITY,
//  FITNESS FOR A PARTICULAR PURPOSE AND NONINFRINGEMENT. IN NO EVENT SHALL THE
//  AUTHORS OR COPYRIGHT HOLDERS BE LIABLE FOR ANY CLAIM, DAMAGES OR OTHER
//  LIABILITY, WHETHER IN AN ACTION OF CONTRACT, TORT OR OTHERWISE, ARISING FROM,
//  OUT OF OR IN CONNECTION WITH THE SOFTWARE OR THE USE OR OTHER DEALINGS IN THE
//  SOFTWARE.

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
