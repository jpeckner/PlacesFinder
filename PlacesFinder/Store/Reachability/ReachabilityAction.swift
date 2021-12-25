//
//  ReachabilityAction.swift
//  PlacesFinder
//
//  Created by Justin Peckner.
//  Copyright © 2019 Justin Peckner. All rights reserved.
//

import SwiftDux

enum ReachabilityAction: Action, Equatable {
    case unreachable
    case reachable(ConnectionType)
}
