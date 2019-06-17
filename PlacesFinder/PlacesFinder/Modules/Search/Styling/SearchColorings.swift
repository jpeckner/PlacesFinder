// swiftlint:disable:this file_name
//
//  SearchColorings.swift
//  PlacesFinder
//
//  Created by Justin Peckner.
//  Copyright © 2019 Justin Peckner. All rights reserved.
//

import Shared

// sourcery: fieldName = "searchCTA"
struct SearchCTAViewColorings: AppColoringProtocol, AppStandardColoringsProtocol {
    let viewColoring: ViewColoring
    let titleTextColoring: TextColoring
    let bodyTextColoring: TextColoring
    let ctaTextColoring: TextColoring
}

// sourcery: fieldName = "searchDetails"
struct SearchDetailsViewColorings: AppColoringProtocol {
    let viewColoring: ViewColoring
    let bodyTextColoring: TextColoring
    let disclosureArrowTint: FillColoring
}

// sourcery: fieldName = "searchInput"
struct SearchInputViewColorings: AppColoringProtocol {
    let viewColoring: ViewColoring
    let textFieldViewColoring: ViewColoring
    let inputTextColoring: TextColoring
    let cancelButtonTextColoring: TextColoring
}

// sourcery: fieldName = "searchProgress"
struct SearchProgressViewColorings: AppColoringProtocol {
    let viewColoring: ViewColoring
    let gradientFill: FillColoring
}

// sourcery: fieldName = "searchResults"
struct SearchResultsViewColorings: AppColoringProtocol {
    let viewColoring: ViewColoring
    let bodyTextColoring: TextColoring
    let disclosureArrowTint: FillColoring
    let refreshControlTint: FillColoring
}
