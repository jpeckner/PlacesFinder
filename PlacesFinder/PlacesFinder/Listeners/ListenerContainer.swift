//
//  ListenerContainer.swift
//  PlacesFinder
//
//  Created by Justin Peckner.
//  Copyright © 2019 Justin Peckner. All rights reserved.
//

import SwiftDux

struct ListenerContainer {
    let locationAuthListener: LocationAuthListenerProtocol
    let reachabilityListener: ReachabilityListenerProtocol?
    let userDefaultsListener: UserDefaultsListenerProtocol
}
