//
//  SearchPreferencesState.swift
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
import SwiftDux

struct SearchPreferencesState: Equatable, Codable {
    let distance: SearchDistance
    let sorting: PlaceLookupSorting
}

extension SearchPreferencesState {

    init(usesMetricSystem: Bool) {
        self.distance = usesMetricSystem ? .metric(.defaultDistance) : .imperial(.defaultDistance)
        self.sorting = .distance
    }

}

// MARK: Reducer

enum SearchPreferencesReducer {

    static func reduce(action: Action,
                       currentState: SearchPreferencesState) -> SearchPreferencesState {
        guard let searchPreferencesAction = action as? SearchPreferencesAction else {
            return currentState
        }

        switch searchPreferencesAction {
        case let .setDistance(distance):
            return SearchPreferencesState(distance: distance,
                                          sorting: currentState.sorting)
        case let .setSorting(sorting):
            return SearchPreferencesState(distance: currentState.distance,
                                          sorting: sorting)
        }
    }

}
