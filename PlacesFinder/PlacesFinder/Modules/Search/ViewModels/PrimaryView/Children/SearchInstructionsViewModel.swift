//
//  SearchInstructionsViewModel.swift
//  PlacesFinder
//
//  Created by Justin Peckner.
//  Copyright © 2019 Justin Peckner. All rights reserved.
//

import Foundation

struct SearchInstructionsViewModel {
    let infoViewModel: StaticInfoViewModel
    let resultsSource: String
}

extension SearchInstructionsCopyContent: StaticInfoCopyProtocol {}

extension SearchInstructionsViewModel {

    init(copyContent: SearchInstructionsCopyContent) {
        self.infoViewModel = copyContent.staticInfoViewModel
        self.resultsSource = copyContent.resultsSource
    }

}
