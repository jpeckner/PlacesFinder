//
//  SearchCTAViewModel+Stub.swift
//  PlacesFinder
//
//  Created by Justin Peckner.
//  Copyright © 2020 Justin Peckner. All rights reserved.
//

import Shared

extension SearchCTAViewModel {

    static func stubValue(infoViewModel: StaticInfoViewModel = .stubValue(),
                          ctaTitle: String = "stubCTATitle",
                          ctaBlock: SearchCTABlock? = nil) -> SearchCTAViewModel {
        return SearchCTAViewModel(infoViewModel: infoViewModel,
                                  ctaTitle: ctaTitle,
                                  ctaBlock: ctaBlock.map { IgnoredEquatable($0) })
    }

}
