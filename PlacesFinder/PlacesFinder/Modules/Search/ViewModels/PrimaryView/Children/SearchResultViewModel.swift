//
//  SearchResultViewModel.swift
//  PlacesFinder
//
//  Created by Justin Peckner.
//  Copyright © 2020 Justin Peckner. All rights reserved.
//

import Shared
import SwiftDux

struct SearchResultViewModel {
    let cellModel: SearchResultCellModel
    let detailEntityAction: Action
}

struct SearchResultsViewModel {
    let resultViewModels: NonEmptyArray<SearchResultViewModel>
}
