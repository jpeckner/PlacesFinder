//
//  SearchRetryViewModel.swift
//  PlacesFinder
//
//  Created by Justin Peckner.
//  Copyright © 2019 Justin Peckner. All rights reserved.
//

import Foundation
import Shared

struct SearchRetryViewModel: Equatable {
    let ctaViewModel: SearchCTAViewModel
}

extension SearchRetryCopyContent: SearchCTACopyProtocol {}

// MARK: SearchRetryViewModelBuilder

protocol SearchRetryViewModelBuilderProtocol: AutoMockable {
    func buildViewModel(_ copyContent: SearchRetryCopyContent,
                        ctaBlock: @escaping SearchCTABlock) -> SearchRetryViewModel
}

class SearchRetryViewModelBuilder: SearchRetryViewModelBuilderProtocol {

    func buildViewModel(_ copyContent: SearchRetryCopyContent,
                        ctaBlock: @escaping SearchCTABlock) -> SearchRetryViewModel {
        let ctaViewModel = SearchCTAViewModel(infoViewModel: copyContent.staticInfoViewModel,
                                              ctaTitle: copyContent.ctaTitle,
                                              ctaBlock: IgnoredEquatable(ctaBlock))

        return SearchRetryViewModel(ctaViewModel: ctaViewModel)
    }

}
