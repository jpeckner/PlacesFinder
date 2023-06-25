//
//  AppConfig.swift
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

enum AppConfigError: Error {
    case displayNameNotFound
    case appVersionNotFound
    case configEntryNotFound
}

struct AppConfig {
    let displayName: NonEmptyString
    let version: NonEmptyString
    let yelpRequestConfig: YelpRequestConfig
}

extension AppConfig {

    init(bundle: Bundle) throws {
        guard let displayNameValue = bundle.infoDictionary?["CFBundleDisplayName"] as? String else {
            throw AppConfigError.displayNameNotFound
        }
        self.displayName = try NonEmptyString(displayNameValue)

        guard let versionValue = bundle.infoDictionary?["CFBundleShortVersionString"] as? String else {
            throw AppConfigError.appVersionNotFound
        }
        self.version = try NonEmptyString(versionValue)

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
