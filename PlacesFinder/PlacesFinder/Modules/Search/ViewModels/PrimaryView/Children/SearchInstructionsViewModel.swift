//
//  SearchInstructionsViewModel.swift
//  PlacesFinder
//
//  Created by Justin Peckner.
//  Copyright © 2019 Justin Peckner. All rights reserved.
//

import Foundation
import Shared

struct SearchInstructionsViewModel: Equatable {
    let infoViewModel: StaticInfoViewModel
    let resultsSource: String
}

extension SearchInstructionsCopyContent: StaticInfoCopyProtocol {}

// MARK: SearchInstructionsViewModelBuilder

protocol SearchInstructionsViewModelBuilderProtocol: AutoMockable {
    func buildViewModel(copyContent: SearchInstructionsCopyContent) -> SearchInstructionsViewModel
}

class SearchInstructionsViewModelBuilder: SearchInstructionsViewModelBuilderProtocol {

    func buildViewModel(copyContent: SearchInstructionsCopyContent) -> SearchInstructionsViewModel {
        return SearchInstructionsViewModel(infoViewModel: copyContent.staticInfoViewModel,
                                           resultsSource: copyContent.resultsSource)
    }

}
