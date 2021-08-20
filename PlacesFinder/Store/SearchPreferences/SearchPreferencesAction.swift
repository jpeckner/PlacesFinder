//
//  SearchPreferencesAction.swift
//  PlacesFinder
//
//  Created by Justin Peckner.
//  Copyright © 2019 Justin Peckner. All rights reserved.
//

import Foundation
import Shared
import SwiftDux

enum SearchPreferencesAction: Action, Equatable {
    case setDistance(SearchDistance)
    case setSorting(PlaceLookupSorting)
}

enum SearchPreferencesActionCreator {

    static func setMeasurementSystem(_ system: MeasurementSystem) -> Action {
        switch system {
        case .imperial:
            return SearchPreferencesAction.setDistance(.imperial(.defaultDistance))
        case .metric:
            return SearchPreferencesAction.setDistance(.metric(.defaultDistance))
        }
    }

}
