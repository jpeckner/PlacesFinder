//
//  SearchActionPrism.swift
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
import SwiftDux

enum SearchActionPrismError: Error {
    case attemptLimitsExceeded
}

protocol SearchInitialActionPrismProtocol {
    func initialRequestAction(_ searchParams: SearchParams,
                              locationUpdateRequestBlock: @escaping LocationUpdateRequestBlock) -> Action
}

protocol SearchSubsequentActionPrismProtocol {
    func subsequentRequestAction(_ searchParams: SearchParams,
                                 allEntities: NonEmptyArray<SearchEntityModel>,
                                 tokenContainer: PlaceLookupTokenAttemptsContainer) throws -> Action
}

protocol SearchUpdateEditingActionPrismProtocol {
    func updateEditingAction(_ editEvent: SearchBarEditEvent) -> Action
}

protocol SearchDetailsActionPrismProtocol {
    var removeDetailedEntityAction: Action { get }

    func detailEntityAction(_ entity: SearchEntityModel) -> Action
}

protocol SearchActionPrismProtocol: SearchInitialActionPrismProtocol,
                                    SearchSubsequentActionPrismProtocol,
                                    SearchUpdateEditingActionPrismProtocol,
                                    SearchDetailsActionPrismProtocol,
                                    AutoMockable {}

class SearchActionPrism: SearchActionPrismProtocol {

    private let dependencies: SearchActionCreatorDependencies
    private let actionCreator: SearchActionCreatorProtocol.Type

    init(dependencies: SearchActionCreatorDependencies,
         actionCreator: SearchActionCreatorProtocol.Type) {
        self.dependencies = dependencies
        self.actionCreator = actionCreator
    }

}

extension SearchActionPrism: SearchInitialActionPrismProtocol {

    func initialRequestAction(_ searchParams: SearchParams,
                              locationUpdateRequestBlock: @escaping LocationUpdateRequestBlock) -> Action {
        return actionCreator.requestInitialPage(dependencies,
                                                searchParams: searchParams,
                                                locationUpdateRequestBlock: locationUpdateRequestBlock)
    }
}

extension SearchActionPrism: SearchSubsequentActionPrismProtocol {

    func subsequentRequestAction(_ searchParams: SearchParams,
                                 allEntities: NonEmptyArray<SearchEntityModel>,
                                 tokenContainer: PlaceLookupTokenAttemptsContainer) throws -> Action {
        let incrementedAttemptsCount = tokenContainer.numAttemptsSoFar + 1
        guard incrementedAttemptsCount <= tokenContainer.maxAttempts else {
            throw SearchActionPrismError.attemptLimitsExceeded
        }

        let updatedTokenContainer = PlaceLookupTokenAttemptsContainer(token: tokenContainer.token,
                                                                      maxAttempts: tokenContainer.maxAttempts,
                                                                      numAttemptsSoFar: incrementedAttemptsCount)

        return actionCreator.requestSubsequentPage(dependencies,
                                                   searchParams: searchParams,
                                                   previousResults: allEntities,
                                                   tokenContainer: updatedTokenContainer)
    }

}

extension SearchActionPrism: SearchUpdateEditingActionPrismProtocol {

    func updateEditingAction(_ editEvent: SearchBarEditEvent) -> Action {
        return SearchAction.updateInputEditing(editEvent)
    }

}

extension SearchActionPrism: SearchDetailsActionPrismProtocol {

    func detailEntityAction(_ entity: SearchEntityModel) -> Action {
        return SearchAction.detailedEntity(entity)
    }

    var removeDetailedEntityAction: Action {
        return SearchAction.removeDetailedEntity
    }

}
