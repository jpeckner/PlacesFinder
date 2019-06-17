//
//  SearchActionCreatorProtocolMock+Verify.swift
//  PlacesFinderTests
//
//  Created by Justin Peckner.
//  Copyright © 2019 Justin Peckner. All rights reserved.
//

import Nimble
#if DEBUG
@testable import PlacesFinder
#endif
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

        SearchActionCreatorProtocolMock.requestInitialPageSubmittedParamsLocationUpdateRequestBlockClosure = { _, _, _ in
            StubSearchAction.requestInitialPage
        }

        SearchActionCreatorProtocolMock.requestSubsequentPageSubmittedParamsPreviousResultsTokenContainerClosure = { _, _, _, _ in
            StubSearchAction.requestSubsequentPage
        }
    }
    // swiftlint:enable line_length

    static func verifyRequestInitialPageCalled(
        with submittedParams: SearchSubmittedParams,
        placeLookupService: PlaceLookupServiceProtocol,
        actionCreator: SearchActionCreatorProtocol.Type
    ) {
        expect(
            SearchActionCreatorProtocolMock
            .requestInitialPageSubmittedParamsLocationUpdateRequestBlockReceivedArguments?
            .submittedParams
        ) == submittedParams

        expect(
            SearchActionCreatorProtocolMock
            .requestInitialPageSubmittedParamsLocationUpdateRequestBlockReceivedArguments?
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
            .requestSubsequentPageSubmittedParamsPreviousResultsTokenContainerReceivedArguments?
            .previousResults.value
        ) == entities

        expect(
            SearchActionCreatorProtocolMock
            .requestSubsequentPageSubmittedParamsPreviousResultsTokenContainerReceivedArguments?
            .tokenContainer
        ) == nextRequestToken

        expect(
            SearchActionCreatorProtocolMock
            .requestSubsequentPageSubmittedParamsPreviousResultsTokenContainerReceivedArguments?
            .dependencies
            .placeLookupService
        ) === placeLookupService
    }

    static func resetAll() {
        SearchActionCreatorProtocolMock.requestInitialPageSubmittedParamsLocationUpdateRequestBlockReset()
        SearchActionCreatorProtocolMock.requestSubsequentPageSubmittedParamsPreviousResultsTokenContainerReset()
    }

}
