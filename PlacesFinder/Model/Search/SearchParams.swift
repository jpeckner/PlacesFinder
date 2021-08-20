//
//  SearchParams.swift
//  PlacesFinder
//
//  Created by Justin Peckner.
//  Copyright © 2019 Justin Peckner. All rights reserved.
//

import Foundation
import Shared

struct SearchParams: Equatable {
    let keywords: NonEmptyString
}

struct SearchInputParams: Equatable {
    let params: SearchParams?
    let isEditing: Bool
}
