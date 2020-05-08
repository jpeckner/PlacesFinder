//
//  PlaceLookupService.swift
//  Shared
//
//  Created by Justin Peckner.
//  Copyright © 2019 Justin Peckner. All rights reserved.
//

import Foundation
import Shared

typealias PlaceLookupResult = Result<PlaceLookupResponse, PlaceLookupServiceError>
typealias PlaceLookupCompletion = (PlaceLookupResult) -> Void

protocol PlaceLookupServiceProtocol: AnyObject, AutoMockable {
    func buildInitialPageRequestToken(_ placeLookupParams: PlaceLookupParams,
                                      resultsPerPage: Int) throws -> PlaceLookupPageRequestToken

    func buildInitialPageRequestToken(_ placeLookupParams: PlaceLookupParams) throws -> PlaceLookupPageRequestToken

    func requestPage(_ requestToken: PlaceLookupPageRequestToken,
                     completion: @escaping PlaceLookupCompletion)
}

// MARK: PlaceLookupServiceError

enum PlaceLookupErrorPayload {
    case codeAndDescription(code: String, description: String)
}

enum PlaceLookupServiceError {
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
