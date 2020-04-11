//
//  SearchInstructionsCopyContent+Stub.swift
//  PlacesFinder
//
//  Created by Justin Peckner.
//  Copyright © 2020 Justin Peckner. All rights reserved.
//

#if DEBUG
@testable import PlacesFinder
#endif

extension SearchInstructionsCopyContent {

    static func stubValue() -> SearchInstructionsCopyContent {
        return SearchInstructionsCopyContent(iconImageName: "stubIconImageName",
                                             title: "stubTitle",
                                             description: "stubDescription",
                                             resultsSource: "stubResultsSource")
    }

}
