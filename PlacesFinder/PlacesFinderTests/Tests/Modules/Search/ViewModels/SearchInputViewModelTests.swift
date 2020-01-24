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
import Shared
import SharedTestComponents

class SearchInputViewModelTests: QuickSpec {

    // swiftlint:disable implicitly_unwrapped_optional
    override func spec() {

        let stubInputKeywords = NonEmptyString.stubValue("stubInputKeywords")
        var result: SearchInputViewModel!

        describe("inputViewModel") {
            beforeEach {
                let copyContent = SearchInputCopyContent(placeholder: "stubPlaceholder",
                                                         cancelButtonTitle: "stubCancelButtonTitle")
                result = SearchInputViewModel(inputKeywords: stubInputKeywords,
                                              copyContent: copyContent)
            }

            it("returns its expected value") {
                expect(result) == SearchInputViewModel(inputKeywords: stubInputKeywords,
                                                       placeholder: "stubPlaceholder",
                                                       cancelButtonTitle: "stubCancelButtonTitle")
            }

        }

    }

}
