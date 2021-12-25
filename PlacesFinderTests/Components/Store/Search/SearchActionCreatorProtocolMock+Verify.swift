//
//  SearchActionCreatorProtocolMock+Verify.swift
//  PlacesFinderTests
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

import Nimble
import Shared
import SharedTestComponents
import SwiftDux

enum StubSearchAction: Action, Equatable {
    case requestInitialPage
    case requestSubsequentPage
}

extension SearchActionCreatorProtocolMock {

    // swiftlint:disable line_length
    static func setup() {
        resetAll()

        SearchActionCreatorProtocolMock.requestInitialPageSearchParamsLocationUpdateRequestBlockClosure = { _, _, _ in
            StubSearchAction.requestInitialPage
        }

        SearchActionCreatorProtocolMock.requestSubsequentPageSearchParamsPreviousResultsTokenContainerClosure = { _, _, _, _ in
            StubSearchAction.requestSubsequentPage
        }
    }
    // swiftlint:enable line_length

    static func verifyRequestInitialPageCalled(
        with submittedParams: SearchParams,
        placeLookupService: PlaceLookupServiceProtocol,
        actionCreator: SearchActionCreatorProtocol.Type
    ) {
        expect(
            SearchActionCreatorProtocolMock
            .requestInitialPageSearchParamsLocationUpdateRequestBlockReceivedArguments?
            .searchParams
        ) == submittedParams

        expect(
            SearchActionCreatorProtocolMock
            .requestInitialPageSearchParamsLocationUpdateRequestBlockReceivedArguments?
            .dependencies
            .placeLookupService
        ) === placeLookupService
    }

    static func verifyRequestSubsequentPageCalled(
        with entities: [SearchEntityModel],
        nextRequestToken: PlaceLookupTokenAttemptsContainer,
        placeLookupService: PlaceLookupServiceProtocol,
        actionCreator: SearchActionCreatorProtocol.Type
    ) {
        expect(
            SearchActionCreatorProtocolMock
            .requestSubsequentPageSearchParamsPreviousResultsTokenContainerReceivedArguments?
            .previousResults.value
        ) == entities

        expect(
            SearchActionCreatorProtocolMock
            .requestSubsequentPageSearchParamsPreviousResultsTokenContainerReceivedArguments?
            .tokenContainer
        ) == nextRequestToken

        expect(
            SearchActionCreatorProtocolMock
            .requestSubsequentPageSearchParamsPreviousResultsTokenContainerReceivedArguments?
            .dependencies
            .placeLookupService
        ) === placeLookupService
    }

    static func resetAll() {
        SearchActionCreatorProtocolMock.requestInitialPageSearchParamsLocationUpdateRequestBlockReset()
        SearchActionCreatorProtocolMock.requestSubsequentPageSearchParamsPreviousResultsTokenContainerReset()
    }

}
