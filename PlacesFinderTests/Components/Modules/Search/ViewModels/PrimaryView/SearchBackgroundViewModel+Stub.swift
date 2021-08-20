//
//  SearchBackgroundViewModel+Stub.swift
//  PlacesFinderTests
//
//  Created by Justin Peckner.
//  Copyright © 2020 Justin Peckner. All rights reserved.
//

import Foundation

extension SearchBackgroundViewModel {

    static func stubValue(
        contentViewModel: SearchInputContentViewModel = .stubValue(),
        instructionsViewModel: SearchInstructionsViewModel = .stubValue()
    ) -> SearchBackgroundViewModel {
        return SearchBackgroundViewModel(contentViewModel: contentViewModel,
                                         instructionsViewModel: instructionsViewModel)
    }

}
