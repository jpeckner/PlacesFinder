//
//  SearchMessageViewModel.swift
//  PlacesFinder
//
//  Created by Justin Peckner.
//  Copyright © 2019 Justin Peckner. All rights reserved.
//

import Foundation

struct SearchMessageViewModel {
    let infoViewModel: StaticInfoViewModel
}

extension SearchMessageViewModel {

    init(copyContent: StaticInfoCopyProtocol) {
        self.infoViewModel = copyContent.staticInfoViewModel
    }

}
