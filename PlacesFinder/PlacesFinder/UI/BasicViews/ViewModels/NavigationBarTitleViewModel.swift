//
//  NavigationBarTitleViewModel.swift
//  PlacesFinder
//
//  Created by Justin Peckner.
//  Copyright © 2020 Justin Peckner. All rights reserved.
//

import Foundation

struct NavigationBarTitleViewModel {
    let displayName: String
}

extension NavigationBarTitleViewModel {

    init(copyContent: DisplayNameCopyContent) {
        self.displayName = copyContent.name.value
    }

}
