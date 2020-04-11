//
//  PlaceLookupService.swift
//  Shared
//
//  Created by Justin Peckner.
//  Copyright © 2019 Justin Peckner. All rights reserved.
//

import Foundation
import Shared

enum PlaceLookupErrorPayload: Equatable {
    case codeAndDescription(code: String, description: String)
}

enum PlaceLookupServiceError: Equatable {
    case errorPayloadReturned(PlaceLookupErrorPayload, urlResponse: HTTPURLResponse)
    case unexpectedDecodingError(underlyingError: DecodableServiceUnexpectedError)
}

extension PlaceLookupServiceError: RetryStatusError {

    var isRetriable: Bool {
        switch self {
        case .unexpectedDecodingError:
            return false
        case let .errorPayloadReturned(_, urlResponse):
            return urlResponse.is500Error
        }
    }

}

struct PlaceLookupResponse: Equatable {
    let page: PlaceLookupPage
    let nextRequestTokenResult: PlaceLookupPageRequestTokenResult?

    init(page: PlaceLookupPage,
                nextRequestTokenResult: PlaceLookupPageRequestTokenResult?) {
        self.page = page
        self.nextRequestTokenResult = nextRequestTokenResult
    }
}

typealias PlaceLookupResult = Result<PlaceLookupResponse, PlaceLookupServiceError>
typealias PlaceLookupCompletion = (PlaceLookupResult) -> Void

// MARK: PlaceLookupService

enum PlaceLookupAPIOption {
    case yelp(YelpRequestConfig)
}

protocol PlaceLookupServiceProtocol: AnyObject, AutoMockable {
    func buildInitialPageRequestToken(_ placeLookupParams: PlaceLookupParams,
                                      resultsPerPage: Int) throws -> PlaceLookupPageRequestToken

    func buildInitialPageRequestToken(_ placeLookupParams: PlaceLookupParams) throws -> PlaceLookupPageRequestToken

    func requestPage(_ requestToken: PlaceLookupPageRequestToken,
                     completion: @escaping PlaceLookupCompletion)
}

class PlaceLookupService {

    static let maxResultsPerPage = YelpRequestBuilder.maxResultsPerPage

    private let standInService: PlaceLookupServiceProtocol

    init(apiOption: PlaceLookupAPIOption,
                decodableService: DecodableServiceProtocol) {
        switch apiOption {
        case let .yelp(config):
            self.standInService = YelpRequestService(config: config,
                                                     decodableService: decodableService)
        }
    }

}

extension PlaceLookupService: PlaceLookupServiceProtocol {

    func buildInitialPageRequestToken(_ placeLookupParams: PlaceLookupParams,
                                             resultsPerPage: Int) throws -> PlaceLookupPageRequestToken {
        return try standInService.buildInitialPageRequestToken(placeLookupParams,
                                                               resultsPerPage: resultsPerPage)
    }

    func buildInitialPageRequestToken(
        _ placeLookupParams: PlaceLookupParams
    ) throws -> PlaceLookupPageRequestToken {
        return try standInService.buildInitialPageRequestToken(placeLookupParams)
    }

    func requestPage(_ requestToken: PlaceLookupPageRequestToken,
                            completion: @escaping PlaceLookupCompletion) {
        standInService.requestPage(requestToken,
                                   completion: completion)
    }

}
