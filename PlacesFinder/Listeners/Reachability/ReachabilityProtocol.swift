//
//  ReachabilityProtocol.swift
//  PlacesFinder
//
//  Copyright (c) 2019 Justin Peckner
//  
//  Permission is hereby granted, free of charge, to any person obtaining a copy
//  of this software and associated documentation files (the "Software"), to deal
//  in the Software without restriction, including without limitation the rights
//  to use, copy, modify, merge, publish, distribute, sublicense, and/or sell
//  copies of the Software, and to permit persons to whom the Software is
//  furnished to do so, subject to the following conditions:
//  
//  The above copyright notice and this permission notice shall be included in all
//  copies or substantial portions of the Software.
//  
//  THE SOFTWARE IS PROVIDED "AS IS", WITHOUT WARRANTY OF ANY KIND, EXPRESS OR
//  IMPLIED, INCLUDING BUT NOT LIMITED TO THE WARRANTIES OF MERCHANTABILITY,
//  FITNESS FOR A PARTICULAR PURPOSE AND NONINFRINGEMENT. IN NO EVENT SHALL THE
//  AUTHORS OR COPYRIGHT HOLDERS BE LIABLE FOR ANY CLAIM, DAMAGES OR OTHER
//  LIABILITY, WHETHER IN AN ACTION OF CONTRACT, TORT OR OTHERWISE, ARISING FROM,
//  OUT OF OR IN CONNECTION WITH THE SOFTWARE OR THE USE OR OTHER DEALINGS IN THE
//  SOFTWARE.

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
            case .none,
                 .unavailable:
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
