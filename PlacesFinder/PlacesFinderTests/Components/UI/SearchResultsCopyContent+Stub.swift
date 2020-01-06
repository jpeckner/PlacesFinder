//
//  SearchResultsCopyContent+Stub.swift
//  PlacesFinder
//
//  Created by Justin Peckner.
//  Copyright © 2020 Justin Peckner. All rights reserved.
//

import Foundation
#if DEBUG
@testable import PlacesFinder
#endif

extension SearchResultsCopyContent {

    static func stubValue() -> SearchResultsCopyContent {
        return SearchResultsCopyContent(
            currencySymbol: "+",
            callNumberFormatString: "callNumberFormatString - %@",
            numRatingsSingularFormatString: "numRatingsSingularFormatString - %d",
            numRatingsPluralFormatString: "numRatingsPluralFormatString - %d"
        )
    }

}
