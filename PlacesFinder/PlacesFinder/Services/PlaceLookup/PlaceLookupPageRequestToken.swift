//
//  PlaceLookupPageRequestToken.swift
//  Shared
//
//  Created by Justin Peckner.
//  Copyright © 2019 Justin Peckner. All rights reserved.
//

import Foundation

public struct PlaceLookupPageRequestToken: Equatable {
    public let placeLookupParams: PlaceLookupParams
    public let urlRequest: URLRequest
    public let startingIndex: Int
    public let resultsPerPage: Int

    public init(placeLookupParams: PlaceLookupParams,
                urlRequest: URLRequest,
                startingIndex: Int,
                resultsPerPage: Int) {
        self.placeLookupParams = placeLookupParams
        self.urlRequest = urlRequest
        self.startingIndex = startingIndex
        self.resultsPerPage = resultsPerPage
    }
}

public struct PlaceLookupTokenAttemptsContainer: Equatable {
    public let token: PlaceLookupPageRequestToken
    public let maxAttempts: Int
    public let numAttemptsSoFar: Int

    public init(token: PlaceLookupPageRequestToken,
                maxAttempts: Int,
                numAttemptsSoFar: Int) {
        self.token = token
        self.maxAttempts = maxAttempts
        self.numAttemptsSoFar = numAttemptsSoFar
    }
}
