//
//  NavigationBarViewModelBuilderTests.swift
//  PlacesFinder
//
//  Created by Justin Peckner.
//  Copyright © 2020 Justin Peckner. All rights reserved.
//

import Nimble
import Quick

class NavigationBarViewModelBuilderTests: QuickSpec {

    // swiftlint:disable implicitly_unwrapped_optional
    override func spec() {

        var sut: NavigationBarViewModelBuilder!
        var result: NavigationBarTitleViewModel!

        beforeEach {
            sut = NavigationBarViewModelBuilder()
        }

        describe("buildTitleViewModel()") {

            beforeEach {
                result = sut.buildTitleViewModel(copyContent: DisplayNameCopyContent.stubValue())
            }

            it("returns its expected value") {
                expect(result) == NavigationBarTitleViewModel(displayName: "stubDisplayName")
            }

        }

    }

}
