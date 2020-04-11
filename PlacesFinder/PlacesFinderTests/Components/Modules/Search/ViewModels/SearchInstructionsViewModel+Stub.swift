//
//  SearchInstructionsViewModel+Stub.swift
//  PlacesFinder
//
//  Created by Justin Peckner.
//  Copyright © 2020 Justin Peckner. All rights reserved.
//

#if DEBUG
@testable import PlacesFinder
#endif

extension SearchInstructionsViewModel {

    static func stubValue(infoViewModel: StaticInfoViewModel = .stubValue(),
                          resultsSource: String = "stubResultsSource") -> SearchInstructionsViewModel {
        return SearchInstructionsViewModel(infoViewModel: infoViewModel,
                                           resultsSource: resultsSource)
    }

}
