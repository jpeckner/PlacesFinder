//
//  SearchInputViewModel.swift
//  PlacesFinder
//
//  Created by Justin Peckner.
//  Copyright © 2019 Justin Peckner. All rights reserved.
//

import Foundation

struct SearchInputViewModel: Equatable {
    let placeholder: String
    let cancelButtonTitle: String
}

extension SearchInputCopyContent {

    var inputViewModel: SearchInputViewModel {
        return SearchInputViewModel(
            placeholder: placeholder,
            cancelButtonTitle: cancelButtonTitle
        )
    }

}
