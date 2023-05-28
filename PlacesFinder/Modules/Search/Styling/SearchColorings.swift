//  swiftlint:disable:this file_name
//
//  SearchColorings.swift
//  PlacesFinder
//
//  Copyright (c) 2019 Justin Peckner
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

import Shared

// sourcery: fieldName = "searchCTA"
struct SearchCTAViewColorings: AppColoringProtocol, AppStandardColoringsProtocol {
    let viewColoring: ViewColoring
    let titleTextColoring: TextColoring
    let bodyTextColoring: TextColoring
    let ctaTextColoring: TextColoring
}

// sourcery: fieldName = "searchDetails"
struct SearchDetailsViewColorings: AppColoringProtocol {
    let viewColoring: ViewColoring
    let bodyTextColoring: TextColoring
    let phoneIconTint: FillColoring
    let disclosureArrowTint: FillColoring
}

// sourcery: fieldName = "searchInput"
struct SearchInputViewColorings: AppColoringProtocol {
    let viewColoring: ViewColoring
    let iconTintColoring: FillColoring
    let textFieldViewColoring: ViewColoring
    let placeholderColoring: TextColoring
    let inputTextColoring: TextColoring
    let cancelButtonTextColoring: TextColoring
}

// sourcery: fieldName = "searchProgress"
struct SearchProgressViewColorings: AppColoringProtocol {
    let viewColoring: ViewColoring
    let gradientFill: FillColoring
    let gradientBackground: FillColoring
}

// sourcery: fieldName = "searchResults"
struct SearchResultsViewColorings: AppColoringProtocol {
    let viewColoring: ViewColoring
    let bodyTextColoring: TextColoring
    let disclosureArrowTint: FillColoring
    let refreshControlTint: FillColoring
}
