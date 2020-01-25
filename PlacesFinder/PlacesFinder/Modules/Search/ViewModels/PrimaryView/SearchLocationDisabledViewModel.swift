//
//  SearchLocationDisabledViewModel.swift
//  PlacesFinder
//
//  Created by Justin Peckner.
//  Copyright © 2020 Justin Peckner. All rights reserved.
//

import Foundation
import Shared

struct SearchLocationDisabledViewModel {
    let ctaViewModel: SearchCTAViewModel
}

extension SearchLocationDisabledCopyContent: SearchCTACopyProtocol {}

extension SearchLocationDisabledViewModel {

    init(urlOpenerService: URLOpenerServiceProtocol,
         copyContent: SearchLocationDisabledCopyContent) {
        self.ctaViewModel = copyContent.ctaViewModel(ctaBlock: urlOpenerService.openSettingsBlock)
    }

}
