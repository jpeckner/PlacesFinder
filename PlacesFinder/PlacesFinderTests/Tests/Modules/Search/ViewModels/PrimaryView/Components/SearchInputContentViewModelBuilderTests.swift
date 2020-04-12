//
//  SearchInputContentViewModelBuilderTests.swift
//  PlacesFinderTests
//
//  Created by Justin Peckner.
//  Copyright © 2019 Justin Peckner. All rights reserved.
//

import Nimble
import Quick
import Shared
import SharedTestComponents

class SearchInputContentViewModelBuilderTests: QuickSpec {

    // swiftlint:disable implicitly_unwrapped_optional
    override func spec() {

        let stubKeywords = NonEmptyString.stubValue("stubInputKeywords")

        var sut: SearchInputContentViewModelBuilder!
        var result: SearchInputContentViewModel!

        beforeEach {
            sut = SearchInputContentViewModelBuilder()
        }

        describe("buildViewModel()") {
            beforeEach {
                let copyContent = SearchInputCopyContent.stubValue()
                result = sut.buildViewModel(keywords: stubKeywords,
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
