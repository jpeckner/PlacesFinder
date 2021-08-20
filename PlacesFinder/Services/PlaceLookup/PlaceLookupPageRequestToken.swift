//
//  PlaceLookupPageRequestToken.swift
//  Shared
//
//  Created by Justin Peckner.
//  Copyright © 2019 Justin Peckner. All rights reserved.
//

import Foundation

struct PlaceLookupPageRequestToken: Equatable {
    let placeLookupParams: PlaceLookupParams
    let urlRequest: URLRequest
    let startingIndex: Int
    let resultsPerPage: Int
}

struct PlaceLookupTokenAttemptsContainer: Equatable {
    let token: PlaceLookupPageRequestToken
    let maxAttempts: Int
    let numAttemptsSoFar: Int
}
