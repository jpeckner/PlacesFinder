//
//  NavigationBarTitleViewModel.swift
//  PlacesFinder
//
//  Created by Justin Peckner.
//  Copyright © 2020 Justin Peckner. All rights reserved.
//

import Foundation
import Shared

struct NavigationBarTitleViewModel: Equatable {
    let displayName: String
}

protocol NavigationBarViewModelBuilderProtocol: AutoMockable {
    func buildTitleViewModel(copyContent: DisplayNameCopyContent) -> NavigationBarTitleViewModel
}

class NavigationBarViewModelBuilder: NavigationBarViewModelBuilderProtocol {

    func buildTitleViewModel(copyContent: DisplayNameCopyContent) -> NavigationBarTitleViewModel {
        return NavigationBarTitleViewModel(displayName: copyContent.name.value)
    }

}
