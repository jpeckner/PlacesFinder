//
//  SettingsPlainHeaderViewModelBuilderTests.swift
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

class SettingsPlainHeaderViewModelBuilderTests: QuickSpec {

    // swiftlint:disable implicitly_unwrapped_optional
    override func spec() {

        var sut: SettingsPlainHeaderViewModelBuilder!
        var result: SettingsPlainHeaderViewModel!

        beforeEach {
            sut = SettingsPlainHeaderViewModelBuilder()
        }

        describe("buildViewModel()") {

            let stubTitle = "stubPlainHeaderTitle"

            beforeEach {
                result = sut.buildViewModel(stubTitle)
            }

            it("returns a viewmodel with the expected title") {
                expect(result.title) == "stubPlainHeaderTitle"
            }

        }

    }

}
