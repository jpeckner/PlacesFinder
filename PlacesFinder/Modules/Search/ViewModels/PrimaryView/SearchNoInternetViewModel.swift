//
//  SearchNoInternetViewModel.swift
//  PlacesFinder
//
//  Created by Justin Peckner.
//  Copyright © 2020 Justin Peckner. All rights reserved.
//

import Foundation

struct SearchNoInternetViewModel {
    let messageViewModel: SearchMessageViewModel
}

extension SearchNoInternetCopyContent: StaticInfoCopyProtocol {}

extension SearchNoInternetViewModel {

    init(copyContent: SearchNoInternetCopyContent) {
        self.messageViewModel = SearchMessageViewModel(copyContent: copyContent)
    }

}
