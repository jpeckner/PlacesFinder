//
//  FakeSearchRequest.swift
//  PlacesFinderUITests
//
//  Created by Justin Peckner.
//  Copyright © 2019 Justin Peckner. All rights reserved.
//

import Foundation

enum FakeSearchRequest: String {
    case fastCasualRestaurants = "Fast casual restaurants"
    case goKarts = "Go Karts"
}

extension FakeSearchRequest {

    var response: String {
        switch self {
        case .fastCasualRestaurants:
            return fastCasualResponse
        case .goKarts:
            return goKartsResponse
        }
    }

}
