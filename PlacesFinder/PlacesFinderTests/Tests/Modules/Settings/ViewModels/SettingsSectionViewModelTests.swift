//
//  SettingsSectionViewModelTests.swift
//  PlacesFinder
//
//  Created by Justin Peckner.
//  Copyright © 2020 Justin Peckner. All rights reserved.
//

import Nimble
#if DEBUG
@testable import PlacesFinder
#endif
import Quick
import Shared
import SharedTestComponents
import SwiftDux
import SwiftDuxTestComponents

class SettingsSectionViewModelTests: QuickSpec {

    // swiftlint:disable implicitly_unwrapped_optional
    override func spec() {

        describe("HeaderType") {

            describe("title") {

                var sut: SettingsSectionViewModel.HeaderType!

                context("when the HeaderType is .plain") {
                    beforeEach {
                        let headerViewModel = SettingsPlainHeaderViewModel(title: "stubHeaderViewModel1")
                        sut = .plain(headerViewModel)
                    }

                    it("returns the header viewmodel's title") {
                        expect(sut.title) == "stubHeaderViewModel1"
                    }
                }

                context("when the HeaderType is .plain") {
                    beforeEach {
                        let headerViewModel = SettingsUnitsHeaderViewModel(title: "stubHeaderViewModel2",
                                                                           systemOptions: [])
                        sut = .measurementSystem(headerViewModel)
                    }

                    it("returns the header viewmodel's title") {
                        expect(sut.title) == "stubHeaderViewModel2"
                    }
                }

            }

        }

    }

}
