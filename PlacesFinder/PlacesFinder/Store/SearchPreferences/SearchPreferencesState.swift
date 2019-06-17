//
//  SearchPreferencesState.swift
//  PlacesFinder
//
//  Created by Justin Peckner.
//  Copyright © 2019 Justin Peckner. All rights reserved.
//

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
