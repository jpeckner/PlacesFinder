//
//  UserDefaultsService.swift
//  PlacesFinder
//
//  Created by Justin Peckner.
//  Copyright © 2019 Justin Peckner. All rights reserved.
//

import Foundation
import Shared

protocol UserDefaultsServiceProtocol: AutoMockable {
    func getSearchPreferences() throws -> SearchPreferencesState
    func setSearchPreferences(_ searchPreferences: SearchPreferencesState) throws
}

enum UserDefaultsServiceError: Error {
    case valueNotFound
}

class UserDefaultsService: UserDefaultsServiceProtocol {

    private let userDefaults: UserDefaults
    private let encoder: JSONEncoder
    private let decoder: JSONDecoder

    init(userDefaults: UserDefaults) {
        self.userDefaults = userDefaults
        self.encoder = JSONEncoder()
        self.decoder = JSONDecoder()
    }

    // MARK: SearchPreferencesState

    private static let searchPreferencesStateKey = "searchPreferencesState"

    func getSearchPreferences() throws -> SearchPreferencesState {
        return try getValue(UserDefaultsService.searchPreferencesStateKey)
    }

    func setSearchPreferences(_ searchPreferences: SearchPreferencesState) throws {
        try setValue(searchPreferences, key: UserDefaultsService.searchPreferencesStateKey)
    }

}

private extension UserDefaultsService {

    func getValue<T: Codable>(_ key: String) throws -> T {
        guard let data = userDefaults.data(forKey: key) else {
            throw UserDefaultsServiceError.valueNotFound
        }

        return try decoder.decode(T.self, from: data)
    }

    func setValue<T: Codable>(_ value: T,
                              key: String) throws {
        let data = try encoder.encode(value)
        userDefaults.setValue(data, forKey: key)
    }

}
