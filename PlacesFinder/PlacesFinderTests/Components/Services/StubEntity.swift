//
//  StubEntity.swift
//  PlacesFinderTests
//
//  Created by Justin Peckner.
//  Copyright © 2018 Justin Peckner. All rights reserved.
//

import Foundation

struct StubEntity: Equatable {
    let stringValue: String
    let intValue: Int
    let doubleValue: Double
}

extension StubEntity {

    static func stubValue() -> StubEntity {
        return StubEntity(stringValue: "ABCDEFG",
                          intValue: 100,
                          doubleValue: 1.5)
    }

}
