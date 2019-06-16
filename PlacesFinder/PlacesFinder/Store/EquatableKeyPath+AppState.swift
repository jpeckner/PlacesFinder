// swiftlint:disable:this file_name
//
//  EquatableKeyPath+AppState.swift
//  PlacesFinder
//
//  Created by Justin Peckner.
//  Copyright © 2019 Justin Peckner. All rights reserved.
//

import Foundation
import SwiftDux

extension Set where Element == EquatableKeyPath<AppState> {

    var partialKeyPaths: Set<PartialKeyPath<AppState>> {
        return Set<PartialKeyPath<AppState>>(map { $0.keyPath })
    }

}
