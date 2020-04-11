//
//  SearchBackgroundViewModel+Stub.swift
//  PlacesFinder
//
//  Created by Justin Peckner.
//  Copyright © 2020 Justin Peckner. All rights reserved.
//

#if DEBUG
@testable import PlacesFinder
#endif

extension SearchBackgroundViewModel {

    static func stubValue(
        contentViewModel: SearchInputContentViewModel = .stubValue(),
        instructionsViewModel: SearchInstructionsViewModel = .stubValue()
    ) -> SearchBackgroundViewModel {
        return SearchBackgroundViewModel(contentViewModel: contentViewModel,
                                         instructionsViewModel: instructionsViewModel)
    }

}
