//
//  SearchRetryViewModel.swift
//  PlacesFinder
//
//  Created by Justin Peckner.
//  Copyright © 2019 Justin Peckner. All rights reserved.
//

import Foundation

struct SearchRetryViewModel {
    let ctaViewModel: SearchCTAViewModel
}

extension SearchRetryCopyContent: SearchCTACopyProtocol {}

extension SearchRetryViewModel {

    init(copyContent: SearchRetryCopyContent,
         ctaBlock: @escaping SearchCTABlock) {
        self.ctaViewModel = SearchCTAViewModel(infoViewModel: copyContent.staticInfoViewModel,
                                               ctaTitle: copyContent.ctaTitle,
                                               ctaBlock: ctaBlock)
    }

}
