//
//  UserDefaultsServiceIntegrationTests.swift
//  PlacesFinderTests
//
//  Created by Justin Peckner.
//  Copyright © 2019 Justin Peckner. All rights reserved.
//

import Nimble
import Quick

class UserDefaultsServiceIntegrationTests: QuickSpec {

    // swiftlint:disable implicitly_unwrapped_optional
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
                let stubSearchPreferencesState = SearchPreferencesState(distance: .imperial(.oneMile),
                                                                        sorting: .reviewCount)

                expect {
                    try userDefaultsService.setSearchPreferences(stubSearchPreferencesState)
                    let retreivedState = try userDefaultsService.getSearchPreferences()
                    return expect(retreivedState) == stubSearchPreferencesState
                }.toNot(throwError())
            }

        }

    }

}
