//
//  UserDefaultsListenerTests.swift
//  PlacesFinderTests
//
//  Created by Justin Peckner.
//  Copyright © 2019 Justin Peckner. All rights reserved.
//

import Nimble
import Quick
import SharedTestComponents
import SwiftDux

class UserDefaultsListenerTests: QuickSpec {

    // swiftlint:disable implicitly_unwrapped_optional
    override func spec() {

        var mockStore: MockAppStore!
        var mockUserDefaultsService: UserDefaultsServiceProtocolMock!
        var listener: UserDefaultsListener<MockAppStore>!

        beforeEach {
            mockStore = MockAppStore()
            mockUserDefaultsService = UserDefaultsServiceProtocolMock()
            listener = UserDefaultsListener(store: mockStore,
                                            userDefaultsService: mockUserDefaultsService)
        }

        describe("start()") {

            beforeEach {
                listener.start()
            }

            it("subscribes to its relevant key paths") {
                let substatesSubscription =
                    mockStore.receivedSubscriptions.last?.subscription
                    as? SubstatesSubscription<UserDefaultsListener<MockAppStore>>

                expect(substatesSubscription?.subscribedPaths.count) == 1
                expect(substatesSubscription?.subscribedPaths.keys.contains(\AppState.searchPreferencesState)) == true
            }

        }

        describe("SubstatesSubscriber") {

            describe("newState()") {

                let stubSearchPreferencesState = SearchPreferencesState(distance: .imperial(.twentyMiles),
                                                                        sorting: .reviewCount)

                beforeEach {
                    let stubState = AppState.stubValue(
                        searchPreferencesState: stubSearchPreferencesState
                    )
                    listener.newState(state: stubState, updatedSubstates: [\AppState.searchPreferencesState])
                }

                it("calls mockUserDefaultsService.setSearchPreferences() with state.searchPreferencesState") {
                    let receivedPreferences = mockUserDefaultsService.setSearchPreferencesReceivedSearchPreferences
                    expect(receivedPreferences) == stubSearchPreferencesState
                }

            }

        }

    }

}
