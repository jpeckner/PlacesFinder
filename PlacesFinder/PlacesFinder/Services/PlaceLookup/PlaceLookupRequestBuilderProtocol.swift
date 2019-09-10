//
//  PlaceLookupRequestBuilderProtocol.swift
//  Shared
//
//  Created by Justin Peckner.
//  Copyright © 2019 Justin Peckner. All rights reserved.
//

import Foundation

public enum PlaceLookupRequestBuilderError: Error, Equatable {
    case invalidResultsPerPageAmount(acceptableRange: ClosedRange<Int>)
    case invalidURL(components: URLComponents)
}

public typealias PlaceLookupPageRequestTokenResult = Result<PlaceLookupPageRequestToken, PlaceLookupRequestBuilderError>

public protocol PlaceLookupRequestBuilderProtocol {
    func buildPageRequestToken(_ placeLookupParams: PlaceLookupParams,
                               startingIndex: Int,
                               resultsPerPage: Int) -> PlaceLookupPageRequestTokenResult
}
