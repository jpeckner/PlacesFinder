//
//  PlaceLookupResponse.swift
//  PlacesFinder
//
//  Created by Justin Peckner.
//  Copyright © 2020 Justin Peckner. All rights reserved.
//

import Foundation

struct PlaceLookupResponse: Equatable {
    let page: PlaceLookupPage
    let nextRequestTokenResult: PlaceLookupPageRequestTokenResult?
}
