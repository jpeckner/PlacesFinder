//
//  SearchInputContentViewModel.swift
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

struct SearchInputContentViewModel: Equatable {
    let keywords: NonEmptyString?
    let barState: SearchInputParams.BarState
    let placeholder: String
}

// MARK: SearchInputContentViewModelBuilder

// sourcery: AutoMockable
// swiftlint:disable:next type_name
protocol SearchInputContentViewModelBuilderProtocol {
    func buildViewModel(keywords: NonEmptyString?,
                        barState: SearchInputParams.BarState,
                        copyContent: SearchInputCopyContent) -> SearchInputContentViewModel
}

class SearchInputContentViewModelBuilder: SearchInputContentViewModelBuilderProtocol {

    func buildViewModel(keywords: NonEmptyString?,
                        barState: SearchInputParams.BarState,
                        copyContent: SearchInputCopyContent) -> SearchInputContentViewModel {
        return SearchInputContentViewModel(keywords: keywords,
                                           barState: barState,
                                           placeholder: copyContent.placeholder)
    }

}
