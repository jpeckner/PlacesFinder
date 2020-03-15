//
//  SearchActionPrism.swift
//  PlacesFinder
//
//  Created by Justin Peckner.
//  Copyright © 2019 Justin Peckner. All rights reserved.
//

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

protocol SearchDetailsActionPrismProtocol {
    func detailEntityAction(_ entity: SearchEntityModel) -> Action
    var removeDetailedEntityAction: Action { get }
}

protocol SearchActionPrismProtocol: SearchInitialActionPrismProtocol,
                                    SearchSubsequentActionPrismProtocol,
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

extension SearchActionPrism: SearchDetailsActionPrismProtocol {

    func detailEntityAction(_ entity: SearchEntityModel) -> Action {
        return SearchAction.detailedEntity(entity)
    }

    var removeDetailedEntityAction: Action {
        return SearchAction.removeDetailedEntity
    }

}
