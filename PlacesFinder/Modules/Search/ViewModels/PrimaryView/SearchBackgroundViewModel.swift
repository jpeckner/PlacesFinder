//
//  SearchBackgroundViewModel.swift
//  PlacesFinder
//
//  Copyright (c) 2020 Justin Peckner
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

import Foundation
import Shared

struct SearchBackgroundViewModel {
    let contentViewModel: SearchInputContentViewModel
    let instructionsViewModel: SearchInstructionsViewModel
}

// MARK: SearchBackgroundViewModelBuilder

// sourcery: AutoMockable
protocol SearchBackgroundViewModelBuilderProtocol {
    func buildViewModel(keywords: NonEmptyString?,
                        appCopyContent: AppCopyContent,
                        colorings: AppStandardColorings) -> SearchBackgroundViewModel
}

class SearchBackgroundViewModelBuilder: SearchBackgroundViewModelBuilderProtocol {

    private let contentViewModelBuilder: SearchInputContentViewModelBuilderProtocol
    private let instructionsViewModelBuilder: SearchInstructionsViewModelBuilderProtocol

    init(contentViewModelBuilder: SearchInputContentViewModelBuilderProtocol,
         instructionsViewModelBuilder: SearchInstructionsViewModelBuilderProtocol) {
        self.contentViewModelBuilder = contentViewModelBuilder
        self.instructionsViewModelBuilder = instructionsViewModelBuilder
    }

    func buildViewModel(keywords: NonEmptyString?,
                        appCopyContent: AppCopyContent,
                        colorings: AppStandardColorings) -> SearchBackgroundViewModel {
        let contentViewModel = contentViewModelBuilder.buildViewModel(
            keywords: keywords,
            barState: .isShowing(isEditing: false),
            copyContent: appCopyContent.searchInput
        )

        let instructionsViewModel = instructionsViewModelBuilder.buildViewModel(
            copyContent: appCopyContent.searchInstructions,
            colorings: colorings
        )

        return SearchBackgroundViewModel(contentViewModel: contentViewModel,
                                         instructionsViewModel: instructionsViewModel)
    }

}
