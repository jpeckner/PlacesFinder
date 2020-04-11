//
//  SearchResultsViewModel+Stub.swift
//  PlacesFinder
//
//  Created by Justin Peckner.
//  Copyright © 2020 Justin Peckner. All rights reserved.
//

#if DEBUG
@testable import PlacesFinder
#endif
import Shared
import SwiftDux

extension SearchResultsViewModel {

    enum StubActions: Action {
        case refreshAction
        case nextRequestAction
    }

    static func stubValue(store: DispatchingStoreProtocol,
                          resultViewModels: NonEmptyArray<SearchResultViewModel>,
                          refreshAction: Action = StubActions.refreshAction,
                          nextRequestAction: Action? = StubActions.nextRequestAction) -> SearchResultsViewModel {
        return SearchResultsViewModel(resultViewModels: resultViewModels,
                                      store: store,
                                      refreshAction: refreshAction,
                                      nextRequestAction: nextRequestAction)
    }

}
