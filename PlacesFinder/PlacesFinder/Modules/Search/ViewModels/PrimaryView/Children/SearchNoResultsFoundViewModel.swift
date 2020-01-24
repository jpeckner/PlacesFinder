//
//  SearchNoResultsFoundViewModel.swift
//  PlacesFinder
//
//  Created by Justin Peckner.
//  Copyright © 2020 Justin Peckner. All rights reserved.
//

import Foundation

struct SearchNoResultsFoundViewModel {
    let messageViewModel: SearchMessageViewModel
}

extension SearchNoResultsCopyContent: StaticInfoCopyProtocol {}

extension SearchNoResultsFoundViewModel {

    init(copyContent: SearchNoResultsCopyContent) {
        self.messageViewModel = SearchMessageViewModel(copyContent: copyContent)
    }

}
