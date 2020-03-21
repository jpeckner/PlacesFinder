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

        let stubSearchParams = SearchParams(keywords: NonEmptyString.stubValue("stubInputKeywords"))
        let stubSearchInputParams = SearchInputParams(params: stubSearchParams)

        var result: SearchInputContentViewModel!

        describe("inputViewModel") {
            beforeEach {
                let copyContent = SearchInputCopyContent(placeholder: "stubPlaceholder")
                result = SearchInputContentViewModel(inputParams: stubSearchInputParams,
                                                     copyContent: copyContent)
            }

            it("returns its expected value") {
                expect(result) == SearchInputContentViewModel(inputParams: stubSearchInputParams,
                                                              placeholder: "stubPlaceholder")
            }

        }

    }

}
