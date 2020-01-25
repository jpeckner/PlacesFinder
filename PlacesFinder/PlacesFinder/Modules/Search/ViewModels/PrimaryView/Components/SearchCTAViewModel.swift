//
//  SearchCTAViewModel.swift
//  PlacesFinder
//
//  Created by Justin Peckner.
//  Copyright © 2020 Justin Peckner. All rights reserved.
//

import Foundation

typealias SearchCTABlock = () -> Void

struct SearchCTAViewModel {
    let infoViewModel: StaticInfoViewModel
    let ctaTitle: String
    let ctaBlock: SearchCTABlock?
}

protocol SearchCTACopyProtocol: StaticInfoCopyProtocol {
    var ctaTitle: String { get }
}

extension SearchCTACopyProtocol {

    func ctaViewModel(ctaBlock: SearchCTABlock?) -> SearchCTAViewModel {
        return SearchCTAViewModel(infoViewModel: staticInfoViewModel,
                                  ctaTitle: ctaTitle,
                                  ctaBlock: ctaBlock)
    }

}
