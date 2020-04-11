//
//  SearchActionCreatorProtocolMock+Verify.swift
//  PlacesFinderTests
//
//  Created by Justin Peckner.
//  Copyright © 2019 Justin Peckner. All rights reserved.
//

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
