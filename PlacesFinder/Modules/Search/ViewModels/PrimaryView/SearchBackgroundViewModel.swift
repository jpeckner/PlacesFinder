//
//  SearchBackgroundViewModel.swift
//  PlacesFinder
//
//  Created by Justin Peckner.
//  Copyright © 2020 Justin Peckner. All rights reserved.
//

import Foundation
import Shared

struct SearchBackgroundViewModel {
    let contentViewModel: SearchInputContentViewModel
    let instructionsViewModel: SearchInstructionsViewModel
}

// MARK: SearchBackgroundViewModelBuilder

protocol SearchBackgroundViewModelBuilderProtocol: AutoMockable {
    func buildViewModel(_ keywords: NonEmptyString?,
                        appCopyContent: AppCopyContent) -> SearchBackgroundViewModel
}

class SearchBackgroundViewModelBuilder: SearchBackgroundViewModelBuilderProtocol {

    private let contentViewModelBuilder: SearchInputContentViewModelBuilderProtocol
    private let instructionsViewModelBuilder: SearchInstructionsViewModelBuilderProtocol

    init(contentViewModelBuilder: SearchInputContentViewModelBuilderProtocol,
         instructionsViewModelBuilder: SearchInstructionsViewModelBuilderProtocol) {
        self.contentViewModelBuilder = contentViewModelBuilder
        self.instructionsViewModelBuilder = instructionsViewModelBuilder
    }

    func buildViewModel(_ keywords: NonEmptyString?,
                        appCopyContent: AppCopyContent) -> SearchBackgroundViewModel {
        let contentViewModel = contentViewModelBuilder.buildViewModel(
            keywords: keywords,
            isEditing: false,
            copyContent: appCopyContent.searchInput
        )

        let instructionsViewModel = instructionsViewModelBuilder.buildViewModel(
            copyContent: appCopyContent.searchInstructions
        )

        return SearchBackgroundViewModel(contentViewModel: contentViewModel,
                                         instructionsViewModel: instructionsViewModel)
    }

}
