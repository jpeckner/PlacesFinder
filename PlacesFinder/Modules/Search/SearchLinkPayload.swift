//
//  SearchLinkPayload.swift
//  PlacesFinder
//
//  Created by Justin Peckner.
//  Copyright © 2019 Justin Peckner. All rights reserved.
//

import Foundation
import Shared

// Note: having two different payloads here isn't actually needed (keywords could be optional instead), but they're
// both here to show how to handle two different payloads that happen to have the same path (/search), and also that
// happen to be handled by the same coordinator (SearchCoordinator).

// sourcery: enumCaseName = "search"
struct SearchLinkPayload: AppLinkPayloadProtocol, Equatable {
    static let keywordsKey = "keywords"

    let keywords: NonEmptyString
}

// sourcery: enumCaseName = "emptySearch"
struct EmptySearchLinkPayload: AppLinkPayloadProtocol, Equatable {}
