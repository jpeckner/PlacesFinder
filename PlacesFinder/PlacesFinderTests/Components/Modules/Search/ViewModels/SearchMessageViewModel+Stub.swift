//
//  SearchMessageViewModel+Stub.swift
//  PlacesFinder
//
//  Created by Justin Peckner.
//  Copyright © 2020 Justin Peckner. All rights reserved.
//

#if DEBUG
@testable import PlacesFinder
#endif

extension SearchMessageViewModel {

    static func stubValue(infoViewModel: StaticInfoViewModel = .stubValue()) -> SearchMessageViewModel {
        return SearchMessageViewModel(infoViewModel: infoViewModel)
    }

}
