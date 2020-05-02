//
//  SearchResultViewModel+Stub.swift
//  PlacesFinderTests
//
//  Created by Justin Peckner.
//  Copyright © 2020 Justin Peckner. All rights reserved.
//

import SwiftDux
import SwiftDuxTestComponents

extension SearchResultViewModel {

    static func stubValue(store: DispatchingStoreProtocol,
                          cellModel: SearchResultCellModel = .stubValue(),
                          detailEntityAction: Action = StubAction.genericAction) -> SearchResultViewModel {
        return SearchResultViewModel(cellModel: cellModel,
                                     store: store,
                                     detailEntityAction: detailEntityAction)
    }

}
