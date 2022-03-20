//
//  SearchActivityActionPrism.swift
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

enum SearchActivityActionPrismError: Error {
    case attemptLimitsExceeded
}

protocol SearchInitialActionPrismProtocol {
    func initialRequestAction(_ searchParams: SearchParams,
                              locationUpdateRequestBlock: @escaping LocationUpdateRequestBlock) -> AppAction
}

protocol SearchSubsequentActionPrismProtocol {
    func subsequentRequestAction(_ searchParams: SearchParams,
                                 allEntities: NonEmptyArray<SearchEntityModel>,
                                 tokenContainer: PlaceLookupTokenAttemptsContainer) throws -> AppAction
}

protocol SearchUpdateEditingActionPrismProtocol {
    func updateEditingAction(_ editEvent: SearchBarEditEvent) -> AppAction
}

protocol SearchDetailsActionPrismProtocol {
    var removeDetailedEntityAction: AppAction { get }

    func detailEntityAction(_ entity: SearchEntityModel) -> AppAction
}

protocol SearchActivityActionPrismProtocol: SearchInitialActionPrismProtocol,
                                    SearchSubsequentActionPrismProtocol,
                                    SearchUpdateEditingActionPrismProtocol,
                                    SearchDetailsActionPrismProtocol,
                                    AutoMockable {}

class SearchActivityActionPrism: SearchActivityActionPrismProtocol {

    private let dependencies: SearchActivityActionCreatorDependencies

    init(dependencies: SearchActivityActionCreatorDependencies) {
        self.dependencies = dependencies
    }

}

extension SearchActivityActionPrism: SearchInitialActionPrismProtocol {

    func initialRequestAction(_ searchParams: SearchParams,
                              locationUpdateRequestBlock: @escaping LocationUpdateRequestBlock) -> AppAction {
        return .searchActivity(.startInitialRequest(dependencies: dependencies,
                                                    searchParams: searchParams,
                                                    locationUpdateRequestBlock: locationUpdateRequestBlock))
    }

}

extension SearchActivityActionPrism: SearchSubsequentActionPrismProtocol {

    func subsequentRequestAction(_ searchParams: SearchParams,
                                 allEntities: NonEmptyArray<SearchEntityModel>,
                                 tokenContainer: PlaceLookupTokenAttemptsContainer) throws -> AppAction {
        let incrementedAttemptsCount = tokenContainer.numAttemptsSoFar + 1
        guard incrementedAttemptsCount <= tokenContainer.maxAttempts else {
            throw SearchActivityActionPrismError.attemptLimitsExceeded
        }

        let updatedTokenContainer = PlaceLookupTokenAttemptsContainer(token: tokenContainer.token,
                                                                      maxAttempts: tokenContainer.maxAttempts,
                                                                      numAttemptsSoFar: incrementedAttemptsCount)

        return .searchActivity(.startSubsequentRequest(dependencies: dependencies,
                                                       searchParams: searchParams,
                                                       previousResults: allEntities,
                                                       tokenContainer: updatedTokenContainer))
    }

}

extension SearchActivityActionPrism: SearchUpdateEditingActionPrismProtocol {

    func updateEditingAction(_ editEvent: SearchBarEditEvent) -> AppAction {
        return .searchActivity(.updateInputEditing(editEvent))
    }

}

extension SearchActivityActionPrism: SearchDetailsActionPrismProtocol {

    func detailEntityAction(_ entity: SearchEntityModel) -> AppAction {
        return .searchActivity(SearchActivityAction.detailedEntity(entity))
    }

    var removeDetailedEntityAction: AppAction {
        return .searchActivity(.removeDetailedEntity)
    }

}
