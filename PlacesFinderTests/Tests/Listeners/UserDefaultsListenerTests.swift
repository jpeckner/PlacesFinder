//
//  UserDefaultsListenerTests.swift
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

                let stubSearchPreferencesState = SearchPreferencesState(
                    stored: StoredSearchPreferences(
                        distance: .imperial(.twentyMiles),
                        sorting: .reviewCount
                    )
                )

                beforeEach {
                    let stubState = AppState.stubValue(
                        searchPreferencesState: stubSearchPreferencesState
                    )
                    listener.newState(state: stubState, updatedSubstates: [\AppState.searchPreferencesState])
                }

                it("calls mockUserDefaultsService.setSearchPreferences() with state.searchPreferencesState") {
                    let receivedPreferences = mockUserDefaultsService.setSearchPreferencesReceivedSearchPreferences
                    expect(receivedPreferences) == stubSearchPreferencesState.stored
                }

            }

        }

    }

}
