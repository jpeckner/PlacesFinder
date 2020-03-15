//
//  MockStore+SearchAction.swift
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
import SwiftDuxTestComponents

extension MockStore {

    var dispatchedSubmittedParams: SearchParams? {
        let dispatchedAction = dispatchedNonAsyncActions.last as? SearchAction
        guard case let .subsequentRequest(submittedParams, _, _, _)? = dispatchedAction else {
            fail("Unexpected value: \(String(describing: dispatchedAction))")
            return nil
        }

        return submittedParams
    }

    var dispatchedPageAction: IntermediateStepLoadAction<SearchPageRequestError>? {
        let dispatchedAction = dispatchedNonAsyncActions.last as? SearchAction
        guard case let .subsequentRequest(_, pageAction, _, _)? = dispatchedAction else {
            fail("Unexpected value: \(String(describing: dispatchedAction))")
            return nil
        }

        return pageAction
    }

    var dispatchedEntities: NonEmptyArray<SearchEntityModel>? {
        let dispatchedAction = dispatchedNonAsyncActions.last as? SearchAction
        guard case let .subsequentRequest(_, _, entities, _)? = dispatchedAction else {
            fail("Unexpected value: \(String(describing: dispatchedAction))")
            return nil
        }

        return entities
    }

    var dispatchedNextRequestToken: PlaceLookupTokenAttemptsContainer? {
        let dispatchedAction = dispatchedNonAsyncActions.last as? SearchAction
        guard case let .subsequentRequest(_, _, _, nextRequestToken)? = dispatchedAction else {
            fail("Unexpected value: \(String(describing: dispatchedAction))")
            return nil
        }

        return nextRequestToken
    }

}
