//
//  EntityLoadBlock.swift
//  PlacesFinder
//
//  Created by Justin Peckner.
//  Copyright © 2019 Justin Peckner. All rights reserved.
//

import Foundation
import Shared

enum EntityError: Error, Equatable {
    case preloadError(underlyingError: IgnoredEquatable<Error>)
    case loadError(underlyingError: IgnoredEquatable<Error>)
}

enum EntityLoadBlock<T, E: Error> {
    case nonThrowing((@escaping (Result<T, E>) -> Void) -> Void)
    case throwing((@escaping (Result<T, E>) -> Void) throws -> Void)
}
