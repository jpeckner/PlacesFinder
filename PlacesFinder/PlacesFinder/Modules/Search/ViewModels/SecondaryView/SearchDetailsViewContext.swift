//
//  SearchDetailsViewContext.swift
//  PlacesFinder
//
//  Created by Justin Peckner.
//  Copyright © 2020 Justin Peckner. All rights reserved.
//

import Shared
import SwiftDux

enum SearchDetailsViewContext {
    case detailedEntity(SearchDetailsViewModel)
    case firstListedEntity(SearchDetailsViewModel)
}

extension SearchDetailsViewContext {

    init?(searchState: SearchState,
          store: DispatchingStoreProtocol,
          actionPrism: SearchDetailsActionPrismProtocol,
          urlOpenerService: URLOpenerServiceProtocol,
          copyFormatter: SearchCopyFormatterProtocol,
          appCopyContent: AppCopyContent) {
        let value: SearchDetailsViewContext? = searchState.detailedEntity.map {
            .detailedEntity(SearchDetailsViewModel(entity: $0,
                                                   store: store,
                                                   actionPrism: actionPrism,
                                                   urlOpenerService: urlOpenerService,
                                                   copyFormatter: copyFormatter,
                                                   resultsCopyContent: appCopyContent.searchResults))
        }
        ?? searchState.entities?.value.first.map {
            .firstListedEntity(SearchDetailsViewModel(entity: $0,
                                                      store: store,
                                                      actionPrism: actionPrism,
                                                      urlOpenerService: urlOpenerService,
                                                      copyFormatter: copyFormatter,
                                                      resultsCopyContent: appCopyContent.searchResults))
        }

        guard let caseValue = value else { return nil }
        self = caseValue
    }

}
