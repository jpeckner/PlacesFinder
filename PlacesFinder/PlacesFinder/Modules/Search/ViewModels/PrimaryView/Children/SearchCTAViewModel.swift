//
//  SearchCTAViewModel.swift
//  PlacesFinder
//
//  Created by Justin Peckner.
//  Copyright © 2019 Justin Peckner. All rights reserved.
//

import Foundation

struct SearchCTAViewModel {
    let infoViewModel: StaticInfoViewModel
    let ctaTitle: String
}

@available(iOS 13.0, *)
class SearchCTAViewModelSUI {
    @Published var infoViewModel: StaticInfoViewModel
    @Published var ctaTitle: String

    init(infoViewModel: StaticInfoViewModel,
         ctaTitle: String) {
        self.infoViewModel = infoViewModel
        self.ctaTitle = ctaTitle
    }
}
