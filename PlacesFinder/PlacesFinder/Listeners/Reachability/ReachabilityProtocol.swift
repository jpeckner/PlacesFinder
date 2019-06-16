//
//  ReachabilityProtocol.swift
//  PlacesFinder
//
//  Created by Justin Peckner.
//  Copyright © 2019 Justin Peckner. All rights reserved.
//

import Foundation
import Reachability
import Shared

enum ConnectionType {
    case cellular
    case wifi
}

enum ReachabilityStatus: Equatable {
    case unreachable
    case reachable(ConnectionType)
}

protocol ReachabilityProtocol: AutoMockable {
    func startNotifier() throws
    func setReachabilityCallback(callback: @escaping (ReachabilityStatus) -> Void)
}

// MARK: Extend Reachability library

extension Reachability: ReachabilityProtocol {

    func setReachabilityCallback(callback: @escaping (ReachabilityStatus) -> Void) {
        whenReachable = {
            switch $0.connection {
            case .none:
                callback(.unreachable)
            case .cellular:
                callback(.reachable(.cellular))
            case .wifi:
                callback(.reachable(.wifi))
            }
        }

        whenUnreachable = { _ in
            callback(.unreachable)
        }
    }

}
