//
//  SearchNoResultsFoundViewModel.swift
//  PlacesFinder
//
//  Created by Justin Peckner.
//  Copyright © 2020 Justin Peckner. All rights reserved.
//

import Foundation
import Shared

struct SearchNoResultsFoundViewModel: Equatable {
    let messageViewModel: SearchMessageViewModel
}

extension SearchNoResultsCopyContent: StaticInfoCopyProtocol {}

// MARK: SearchNoResultsFoundViewModelBuilder

protocol SearchNoResultsFoundViewModelBuilderProtocol: AutoMockable {
    func buildViewModel(_ copyContent: SearchNoResultsCopyContent) -> SearchNoResultsFoundViewModel
}

class SearchNoResultsFoundViewModelBuilder: SearchNoResultsFoundViewModelBuilderProtocol {

    func buildViewModel(_ copyContent: SearchNoResultsCopyContent) -> SearchNoResultsFoundViewModel {
        return SearchNoResultsFoundViewModel(messageViewModel: SearchMessageViewModel(copyContent: copyContent))
    }

}
