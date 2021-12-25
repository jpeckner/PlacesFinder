//
//  SearchInputContentViewModel.swift
//  PlacesFinder
//
//  Created by Justin Peckner.
//  Copyright © 2020 Justin Peckner. All rights reserved.
//

import Foundation
import Shared

struct SearchInputContentViewModel: Equatable {
    let keywords: NonEmptyString?
    let isEditing: Bool
    let placeholder: String
}

// MARK: SearchInputContentViewModelBuilder

protocol SearchInputContentViewModelBuilderProtocol: AutoMockable {
    func buildViewModel(keywords: NonEmptyString?,
                        isEditing: Bool,
                        copyContent: SearchInputCopyContent) -> SearchInputContentViewModel
}

class SearchInputContentViewModelBuilder: SearchInputContentViewModelBuilderProtocol {

    func buildViewModel(keywords: NonEmptyString?,
                        isEditing: Bool,
                        copyContent: SearchInputCopyContent) -> SearchInputContentViewModel {
        return SearchInputContentViewModel(keywords: keywords,
                                           isEditing: isEditing,
                                           placeholder: copyContent.placeholder)
    }

}
