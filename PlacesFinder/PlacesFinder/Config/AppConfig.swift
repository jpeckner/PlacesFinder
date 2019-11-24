//
//  AppConfig.swift
//  PlacesFinder
//
//  Created by Justin Peckner.
//  Copyright © 2019 Justin Peckner. All rights reserved.
//

import Foundation
import Shared

enum AppConfigError: Error {
    case displayNameNotFound
    case configEntryNotFound
}

struct AppConfig {
    let displayName: NonEmptyString
    let yelpRequestConfig: YelpRequestConfig
}

extension AppConfig {

    init(bundle: Bundle) throws {
        guard let displayNameValue = bundle.infoDictionary?["CFBundleDisplayName"] as? String else {
            throw AppConfigError.displayNameNotFound
        }
        self.displayName = try NonEmptyString(displayNameValue)

        let decodableConfig = try bundle.decodeAppConfig()
        self.yelpRequestConfig = try YelpRequestConfig(apiKey: decodableConfig.placeLookup.apiKey,
                                                       baseURL: decodableConfig.placeLookup.baseURL)
    }

}

private struct DecodableAppConfig: Decodable {
    let placeLookup: SearchConfig
}

private extension Bundle {

    func decodeAppConfig() throws -> DecodableAppConfig {
        guard let plistPath = url(forResource: "AppConfig", withExtension: "plist") else {
            throw AppConfigError.configEntryNotFound
        }

        let data = try Data(contentsOf: plistPath)
        return try PropertyListDecoder().decode(DecodableAppConfig.self, from: data)
    }

}
