//
//  PlaceLookupService.swift
//  PlacesFinder
//
//  Copyright (c) 2019 Justin Peckner
//  
//  Permission is hereby granted, free of charge, to any person obtaining a copy
//  of this software and associated documentation files (the "Software"), to deal
//  in the Software without restriction, including without limitation the rights
//  to use, copy, modify, merge, publish, distribute, sublicense, and/or sell
//  copies of the Software, and to permit persons to whom the Software is
//  furnished to do so, subject to the following conditions:
//  
//  The above copyright notice and this permission notice shall be included in all
//  copies or substantial portions of the Software.
//  
//  THE SOFTWARE IS PROVIDED "AS IS", WITHOUT WARRANTY OF ANY KIND, EXPRESS OR
//  IMPLIED, INCLUDING BUT NOT LIMITED TO THE WARRANTIES OF MERCHANTABILITY,
//  FITNESS FOR A PARTICULAR PURPOSE AND NONINFRINGEMENT. IN NO EVENT SHALL THE
//  AUTHORS OR COPYRIGHT HOLDERS BE LIABLE FOR ANY CLAIM, DAMAGES OR OTHER
//  LIABILITY, WHETHER IN AN ACTION OF CONTRACT, TORT OR OTHERWISE, ARISING FROM,
//  OUT OF OR IN CONNECTION WITH THE SOFTWARE OR THE USE OR OTHER DEALINGS IN THE
//  SOFTWARE.

import Foundation
import Shared

typealias PlaceLookupResult = Result<PlaceLookupResponse, PlaceLookupServiceError>

// sourcery:AutoMockable
protocol PlaceLookupServiceProtocol: AnyObject {
    func buildInitialPageRequestToken(placeLookupParams: PlaceLookupParams) throws -> PlaceLookupPageRequestToken

    func requestPage(requestToken: PlaceLookupPageRequestToken) async -> PlaceLookupResult
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
