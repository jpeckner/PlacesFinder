//
//  SearchMessageViewModel+Stub.swift
//  PlacesFinderTests
//
//  Created by Justin Peckner.
//  Copyright © 2020 Justin Peckner. All rights reserved.
//

import Foundation

extension SearchMessageViewModel {

    static func stubValue(infoViewModel: StaticInfoViewModel = .stubValue()) -> SearchMessageViewModel {
        return SearchMessageViewModel(infoViewModel: infoViewModel)
    }

}
