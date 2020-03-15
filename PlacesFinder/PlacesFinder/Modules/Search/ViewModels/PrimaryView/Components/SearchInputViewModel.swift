//
//  SearchInputViewModel.swift
//  PlacesFinder
//
//  Created by Justin Peckner.
//  Copyright © 2019 Justin Peckner. All rights reserved.
//

import Foundation
import Shared

struct SearchInputViewModel: Equatable {
    let searchParams: SearchParams?
    let placeholder: String
    let cancelButtonTitle: String
}

extension SearchInputViewModel {

    init(searchParams: SearchParams?,
         copyContent: SearchInputCopyContent) {
        self.searchParams = searchParams
        self.placeholder = copyContent.placeholder
        self.cancelButtonTitle = copyContent.cancelButtonTitle
    }

}
