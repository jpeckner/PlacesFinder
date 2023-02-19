// Generated using Sourcery 2.0.1 — https://github.com/krzysztofzablocki/Sourcery
// DO NOT EDIT

extension SearchDistance {

    enum CodingKeys: String, CodingKey {
        case imperial
        case metric
    }

    internal init(from decoder: Decoder) throws {
        let container = try decoder.container(keyedBy: CodingKeys.self)

        if container.allKeys.contains(.imperial), try container.decodeNil(forKey: .imperial) == false {
            var associatedValues = try container.nestedUnkeyedContainer(forKey: .imperial)
            let associatedValue0 = try associatedValues.decode(SearchDistanceImperial.self)
            self = .imperial(associatedValue0)
            return
        }
        if container.allKeys.contains(.metric), try container.decodeNil(forKey: .metric) == false {
            var associatedValues = try container.nestedUnkeyedContainer(forKey: .metric)
            let associatedValue0 = try associatedValues.decode(SearchDistanceMetric.self)
            self = .metric(associatedValue0)
            return
        }
        throw DecodingError.dataCorrupted(.init(codingPath: decoder.codingPath, debugDescription: "Unknown enum case"))
    }

    internal func encode(to encoder: Encoder) throws {
        var container = encoder.container(keyedBy: CodingKeys.self)

        switch self {
        case let .imperial(associatedValue0):
            var associatedValues = container.nestedUnkeyedContainer(forKey: .imperial)
            try associatedValues.encode(associatedValue0)
        case let .metric(associatedValue0):
            var associatedValues = container.nestedUnkeyedContainer(forKey: .metric)
            try associatedValues.encode(associatedValue0)
        }
    }

}

extension SearchDistanceImperial {

    enum CodingKeys: String, CodingKey {
        case oneMile
        case fiveMiles
        case tenMiles
        case twentyMiles
    }

    internal init(from decoder: Decoder) throws {
        let container = try decoder.singleValueContainer()

        let enumCase = try container.decode(String.self)
        switch enumCase {
        case CodingKeys.oneMile.rawValue: self = .oneMile
        case CodingKeys.fiveMiles.rawValue: self = .fiveMiles
        case CodingKeys.tenMiles.rawValue: self = .tenMiles
        case CodingKeys.twentyMiles.rawValue: self = .twentyMiles
        default: throw DecodingError.dataCorrupted(.init(codingPath: decoder.codingPath, debugDescription: "Unknown enum case '\(enumCase)'"))
        }
    }

    internal func encode(to encoder: Encoder) throws {
        var container = encoder.singleValueContainer()

        switch self {
        case .oneMile: try container.encode(CodingKeys.oneMile.rawValue)
        case .fiveMiles: try container.encode(CodingKeys.fiveMiles.rawValue)
        case .tenMiles: try container.encode(CodingKeys.tenMiles.rawValue)
        case .twentyMiles: try container.encode(CodingKeys.twentyMiles.rawValue)
        }
    }

}

extension SearchDistanceMetric {

    enum CodingKeys: String, CodingKey {
        case fiveKilometers
        case tenKilometers
        case twentyKilometers
        case fortyKilometers
    }

    internal init(from decoder: Decoder) throws {
        let container = try decoder.singleValueContainer()

        let enumCase = try container.decode(String.self)
        switch enumCase {
        case CodingKeys.fiveKilometers.rawValue: self = .fiveKilometers
        case CodingKeys.tenKilometers.rawValue: self = .tenKilometers
        case CodingKeys.twentyKilometers.rawValue: self = .twentyKilometers
        case CodingKeys.fortyKilometers.rawValue: self = .fortyKilometers
        default: throw DecodingError.dataCorrupted(.init(codingPath: decoder.codingPath, debugDescription: "Unknown enum case '\(enumCase)'"))
        }
    }

    internal func encode(to encoder: Encoder) throws {
        var container = encoder.singleValueContainer()

        switch self {
        case .fiveKilometers: try container.encode(CodingKeys.fiveKilometers.rawValue)
        case .tenKilometers: try container.encode(CodingKeys.tenKilometers.rawValue)
        case .twentyKilometers: try container.encode(CodingKeys.twentyKilometers.rawValue)
        case .fortyKilometers: try container.encode(CodingKeys.fortyKilometers.rawValue)
        }
    }

}
