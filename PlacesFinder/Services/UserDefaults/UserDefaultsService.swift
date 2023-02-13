//
//  UserDefaultsService.swift
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

// sourcery: AutoMockable
protocol UserDefaultsServiceProtocol {
    func getSearchPreferences() throws -> StoredSearchPreferences
    func setSearchPreferences(_ searchPreferences: StoredSearchPreferences) throws
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

    func getSearchPreferences() throws -> StoredSearchPreferences {
        return try getValue(UserDefaultsService.searchPreferencesStateKey)
    }

    func setSearchPreferences(_ searchPreferences: StoredSearchPreferences) throws {
        try setValue(searchPreferences, key: UserDefaultsService.searchPreferencesStateKey)
    }

}

private extension UserDefaultsService {

    func getValue<T: Decodable>(_ key: String) throws -> T {
        guard let data = userDefaults.data(forKey: key) else {
            throw UserDefaultsServiceError.valueNotFound
        }

        return try decoder.decode(T.self, from: data)
    }

    func setValue<T: Encodable>(_ value: T,
                                key: String) throws {
        let data = try encoder.encode(value)
        userDefaults.setValue(data, forKey: key)
    }

}
