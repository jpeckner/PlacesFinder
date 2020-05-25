//
//  SearchResultViewModel+Stub.swift
//  PlacesFinderTests
//
//  Created by Justin Peckner.
//  Copyright © 2020 Justin Peckner. All rights reserved.
//

import Shared
import SwiftDux
import SwiftDuxTestComponents

extension SearchResultViewModel {

    static func stubValue(id: NonEmptyString,
                          store: DispatchingStoreProtocol,
                          cellModel: SearchResultCellModel = .stubValue(),
                          detailEntityAction: Action = StubAction.genericAction) -> SearchResultViewModel {
        return SearchResultViewModel(id: id,
                                     cellModel: cellModel,
                                     store: store,
                                     detailEntityAction: detailEntityAction)
    }

}
