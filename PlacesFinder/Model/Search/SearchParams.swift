//
//  SearchParams.swift
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

import Foundation
import Shared

struct SearchParams: Equatable, Sendable {
    let keywords: NonEmptyString
}

struct SearchInputParams: Equatable {
    enum BarState: Equatable {
        case isShowing(isEditing: Bool)
        case isHidden
    }

    let params: SearchParams?
    let barState: BarState
}

extension SearchInputParams.BarState {

    var isEditing: Bool {
        switch self {
        case let .isShowing(isEditing):
            return isEditing

        case .isHidden:
            return false
        }
    }

    var isSearchInputVisible: Bool {
        switch self {
        case .isShowing:
            return true

        case .isHidden:
            return false
        }
    }

}
