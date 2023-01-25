//
//  TestDispatchingStoreProtocol+SearchActivityAction.swift
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
import SwiftDux
import SwiftDuxTestComponents

extension TestDispatchingStoreProtocol {

    var dispatchedSubmittedParams: SearchParams? {
        let dispatchedAction = dispatchedActions.last as? Search.Action
        guard case let .searchActivity(.subsequentRequest(submittedParams, _, _, _))? = dispatchedAction else {
            return nil
        }

        return submittedParams
    }

    var dispatchedPageAction: IntermediateStepLoadAction<Search.PageRequestError>? {
        let dispatchedAction = dispatchedActions.last as? Search.Action
        guard case let .searchActivity(.subsequentRequest(_, pageAction, _, _))? = dispatchedAction else {
            return nil
        }

        return pageAction
    }

    var dispatchedEntities: NonEmptyArray<SearchEntityModel>? {
        let dispatchedAction = dispatchedActions.last as? Search.Action
        guard case let .searchActivity(.subsequentRequest(_, _, entities, _))? = dispatchedAction else {
            return nil
        }

        return entities
    }

    var dispatchedNextRequestToken: PlaceLookupTokenAttemptsContainer? {
        let dispatchedAction = dispatchedActions.last as? Search.Action
        guard case let .searchActivity(.subsequentRequest(_, _, _, nextRequestToken))? = dispatchedAction else {
            return nil
        }

        return nextRequestToken
    }

}
