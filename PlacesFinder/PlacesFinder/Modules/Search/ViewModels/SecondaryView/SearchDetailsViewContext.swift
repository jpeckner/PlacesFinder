//
//  SearchDetailsViewContext.swift
//  PlacesFinder
//
//  Created by Justin Peckner.
//  Copyright © 2020 Justin Peckner. All rights reserved.
//

import Shared
import SwiftDux

enum SearchDetailsViewContext: Equatable {
    case detailedEntity(SearchDetailsViewModel)
    case firstListedEntity(SearchDetailsViewModel)
}

// MARK: SearchDetailsViewContextBuilder

protocol SearchDetailsViewContextBuilderProtocol: AutoMockable {
    func buildViewContext(_ searchState: SearchState,
                          appCopyContent: AppCopyContent) -> SearchDetailsViewContext?
}

class SearchDetailsViewContextBuilder: SearchDetailsViewContextBuilderProtocol {

    private let detailsViewModelBuilder: SearchDetailsViewModelBuilderProtocol

    init(detailsViewModelBuilder: SearchDetailsViewModelBuilderProtocol) {
        self.detailsViewModelBuilder = detailsViewModelBuilder
    }

    func buildViewContext(_ searchState: SearchState,
                          appCopyContent: AppCopyContent) -> SearchDetailsViewContext? {
        return searchState.detailedEntity.map {
            let viewModel = detailsViewModelBuilder.buildViewModel($0,
                                                                   resultsCopyContent: appCopyContent.searchResults)
            return .detailedEntity(viewModel)
        }
        ?? searchState.entities?.value.first.map {
            let viewModel = detailsViewModelBuilder.buildViewModel($0,
                                                                   resultsCopyContent: appCopyContent.searchResults)
            return .firstListedEntity(viewModel)
        }
    }

}
