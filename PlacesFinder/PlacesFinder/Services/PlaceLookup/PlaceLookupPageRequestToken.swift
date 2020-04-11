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

    init(placeLookupParams: PlaceLookupParams,
                urlRequest: URLRequest,
                startingIndex: Int,
                resultsPerPage: Int) {
        self.placeLookupParams = placeLookupParams
        self.urlRequest = urlRequest
        self.startingIndex = startingIndex
        self.resultsPerPage = resultsPerPage
    }
}

struct PlaceLookupTokenAttemptsContainer: Equatable {
    let token: PlaceLookupPageRequestToken
    let maxAttempts: Int
    let numAttemptsSoFar: Int

    init(token: PlaceLookupPageRequestToken,
                maxAttempts: Int,
                numAttemptsSoFar: Int) {
        self.token = token
        self.maxAttempts = maxAttempts
        self.numAttemptsSoFar = numAttemptsSoFar
    }
}
