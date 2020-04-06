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

class SearchInputContentViewModelTests: QuickSpec {

    // swiftlint:disable implicitly_unwrapped_optional
    override func spec() {

        let stubKeywords = NonEmptyString.stubValue("stubInputKeywords")

        var result: SearchInputContentViewModel!

        describe("inputViewModel") {
            beforeEach {
                let copyContent = SearchInputCopyContent(placeholder: "stubPlaceholder")
                result = SearchInputContentViewModel(keywords: stubKeywords,
                                                     isEditing: false,
                                                     copyContent: copyContent)
            }

            it("returns its expected value") {
                expect(result) == SearchInputContentViewModel(keywords: stubKeywords,
                                                              isEditing: false,
                                                              placeholder: "stubPlaceholder")
            }

        }

    }

}
