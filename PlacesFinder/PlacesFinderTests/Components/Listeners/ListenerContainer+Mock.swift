//
//  ListenerContainer+Mock.swift
//  PlacesFinderTests
//
//  Created by Justin Peckner.
//  Copyright © 2019 Justin Peckner. All rights reserved.
//

import Foundation
#if DEBUG
@testable import PlacesFinder
#endif

extension ListenerContainer {

    static func mockValue(
        locationAuthListener: LocationAuthListenerProtocol = LocationAuthListenerProtocolMock(),
        reachabilityListener: ReachabilityListenerProtocol? = ReachabilityListenerProtocolMock(),
        userDefaultsListener: UserDefaultsListenerProtocol = UserDefaultsListenerProtocolMock()
    ) -> ListenerContainer {
        return ListenerContainer(locationAuthListener: locationAuthListener,
                                 reachabilityListener: reachabilityListener,
                                 userDefaultsListener: userDefaultsListener)
    }

}
