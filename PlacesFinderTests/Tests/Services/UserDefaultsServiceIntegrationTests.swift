//
//  UserDefaultsServiceIntegrationTests.swift
//  PlacesFinderTests
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

import Nimble
import Quick

// swiftlint:disable blanket_disable_command
// swiftlint:disable implicitly_unwrapped_optional
class UserDefaultsServiceIntegrationTests: QuickSpec {

    override func spec() {

        var userDefaults: UserDefaults!
        var userDefaultsService: UserDefaultsService!

        beforeEach {
            userDefaults = UserDefaults(suiteName: #file)
            userDefaults.removePersistentDomain(forName: #file)

            userDefaultsService = UserDefaultsService(userDefaults: userDefaults)
        }

        describe("searchPreferences") {

            it("can set and get searchPreferencesState values") {
                let stubSearchPreferences = StoredSearchPreferences(
                    distance: .imperial(.oneMile),
                    sorting: .reviewCount
                )

                expect {
                    try userDefaultsService.setSearchPreferences(stubSearchPreferences)
                    let retreivedPreferences = try userDefaultsService.getSearchPreferences()
                    return expect(retreivedPreferences) == stubSearchPreferences
                }.toNot(throwError())
            }

        }

    }

}
// swiftlint:enable blanket_disable_command
