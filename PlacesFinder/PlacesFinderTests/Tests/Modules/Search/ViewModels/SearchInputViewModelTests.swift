//
//  SearchInputViewModelTests.swift
//  PlacesFinderTests
//
//  Created by Justin Peckner.
//  Copyright © 2019 Justin Peckner. All rights reserved.
//

import Nimble
#if DEBUG
@testable import PlacesFinder
#endif
import Quick

class SearchInputViewModelTests: QuickSpec {

    // swiftlint:disable implicitly_unwrapped_optional
    override func spec() {

        var result: SearchInputViewModel!

        describe("inputViewModel") {
            beforeEach {
                let copyContent = SearchInputCopyContent(placeholder: "stubPlaceholder",
                                                         cancelButtonTitle: "stubCancelButtonTitle")
                result = copyContent.inputViewModel
            }

            it("returns its expected value") {
                expect(result) == SearchInputViewModel(placeholder: "stubPlaceholder",
                                                       cancelButtonTitle: "stubCancelButtonTitle")
            }

        }

    }

}
