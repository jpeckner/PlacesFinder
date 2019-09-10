//
//  PlaceLookupService.swift
//  Shared
//
//  Created by Justin Peckner.
//  Copyright © 2019 Justin Peckner. All rights reserved.
//

import Foundation
import Shared

public enum PlaceLookupErrorPayload: Equatable {
    case codeAndDescription(code: String, description: String)
}

public enum PlaceLookupServiceError: Equatable {
    case errorPayloadReturned(PlaceLookupErrorPayload, urlResponse: HTTPURLResponse)
    case unexpectedDecodingError(underlyingError: DecodableServiceUnexpectedError)
}

extension PlaceLookupServiceError: RetryStatusError {

    public var isRetriable: Bool {
        switch self {
        case .unexpectedDecodingError:
            return false
        case let .errorPayloadReturned(_, urlResponse):
            return urlResponse.is500Error
        }
    }

}

public struct PlaceLookupResponse: Equatable {
    public let page: PlaceLookupPage
    public let nextRequestTokenResult: PlaceLookupPageRequestTokenResult?

    public init(page: PlaceLookupPage,
                nextRequestTokenResult: PlaceLookupPageRequestTokenResult?) {
        self.page = page
        self.nextRequestTokenResult = nextRequestTokenResult
    }
}

public typealias PlaceLookupResult = Result<PlaceLookupResponse, PlaceLookupServiceError>
public typealias PlaceLookupCompletion = (PlaceLookupResult) -> Void

// MARK: PlaceLookupService

public enum PlaceLookupAPIOption {
    case yelp(YelpRequestConfig)
}

public protocol PlaceLookupServiceProtocol: AnyObject, AutoMockable {
    func buildInitialPageRequestToken(_ placeLookupParams: PlaceLookupParams,
                                      resultsPerPage: Int) throws -> PlaceLookupPageRequestToken

    func buildInitialPageRequestToken(_ placeLookupParams: PlaceLookupParams) throws -> PlaceLookupPageRequestToken

    func requestPage(_ requestToken: PlaceLookupPageRequestToken,
                     completion: @escaping PlaceLookupCompletion)
}

public class PlaceLookupService {

    public static let maxResultsPerPage = YelpRequestBuilder.maxResultsPerPage

    private let standInService: PlaceLookupServiceProtocol

    public init(apiOption: PlaceLookupAPIOption,
                decodableService: DecodableServiceProtocol) {
        switch apiOption {
        case let .yelp(config):
            self.standInService = YelpRequestService(config: config,
                                                     decodableService: decodableService)
        }
    }

}

extension PlaceLookupService: PlaceLookupServiceProtocol {

    public func buildInitialPageRequestToken(_ placeLookupParams: PlaceLookupParams,
                                             resultsPerPage: Int) throws -> PlaceLookupPageRequestToken {
        return try standInService.buildInitialPageRequestToken(placeLookupParams,
                                                               resultsPerPage: resultsPerPage)
    }

    public func buildInitialPageRequestToken(
        _ placeLookupParams: PlaceLookupParams
    ) throws -> PlaceLookupPageRequestToken {
        return try standInService.buildInitialPageRequestToken(placeLookupParams)
    }

    public func requestPage(_ requestToken: PlaceLookupPageRequestToken,
                            completion: @escaping PlaceLookupCompletion) {
        standInService.requestPage(requestToken,
                                   completion: completion)
    }

}
