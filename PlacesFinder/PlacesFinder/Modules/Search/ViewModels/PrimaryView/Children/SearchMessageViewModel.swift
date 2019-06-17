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

extension StaticInfoCopyProtocol {

    var messageViewModel: SearchMessageViewModel {
        return SearchMessageViewModel(infoViewModel: staticInfoViewModel)
    }

}
