//
//  SearchConfig.swift
//  PlacesFinder
//
//  Created by Justin Peckner.
//  Copyright © 2018 Justin Peckner. All rights reserved.
//

import Foundation
import Shared

struct SearchConfig: Decodable {
    let apiKey: String
    let baseURL: URL
}
