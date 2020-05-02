//
//  SettingsCellViewModelTests.swift
//  PlacesFinderTests
//
//  Created by Justin Peckner.
//  Copyright © 2020 Justin Peckner. All rights reserved.
//

import Nimble
import Quick
import Shared
import SharedTestComponents
import SwiftDux
import SwiftDuxTestComponents

class SettingsCellViewModelTests: QuickSpec {

    // swiftlint:disable implicitly_unwrapped_optional
    override func spec() {

        var mockStore: MockAppStore!

        var sut: SettingsCellViewModel!

        beforeEach {
            mockStore = MockAppStore()

            sut = SettingsCellViewModel(id: 0,
                                        title: "",
                                        isSelected: false,
                                        store: mockStore,
                                        action: StubAction.genericAction)
        }

        describe("dispatchAction()") {

            beforeEach {
                sut.dispatchAction()
            }

            it("dispatches the cell's action") {
                expect(mockStore.dispatchedActions.first as? StubAction) == .genericAction
            }

        }

    }

}
