//
//  SearchActivityStatePrism.swift
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
import Shared
import SwiftDux

typealias LocationAuthRequestBlock = () -> Void
typealias LocationUpdateRequestBlock = (@escaping (LocationRequestResult) -> Void) -> Void

enum SearchPresentationType: Equatable {
    enum LocationServicesBlock {
        case locationServicesNotDetermined(authBlock: LocationAuthRequestBlock)
        case locationServicesEnabled(requestBlock: LocationUpdateRequestBlock)
    }

    case noInternet
    case locationServicesDisabled
    case search(IgnoredEquatable<LocationServicesBlock>)
}

protocol SearchActivityStatePrismProtocol: AutoMockable {
    func presentationType(locationAuthState: LocationAuthState,
                          reachabilityState: ReachabilityState) -> SearchPresentationType
}

class SearchActivityStatePrism: SearchActivityStatePrismProtocol {

    let locationAuthListener: LocationAuthListenerProtocol
    let locationRequestHandler: LocationRequestHandlerProtocol

    init(locationAuthListener: LocationAuthListenerProtocol,
         locationRequestHandler: LocationRequestHandlerProtocol) {
        self.locationAuthListener = locationAuthListener
        self.locationRequestHandler = locationRequestHandler
    }

    func presentationType(locationAuthState: LocationAuthState,
                          reachabilityState: ReachabilityState) -> SearchPresentationType {
        if case .unreachable? = reachabilityState.status { return .noInternet }

        let locationAuthListener = self.locationAuthListener
        let locationRequestHandler = self.locationRequestHandler
        switch locationAuthState.authStatus {
        case .notDetermined:
            return .search(IgnoredEquatable(.locationServicesNotDetermined {
                locationAuthListener.requestWhenInUseAuthorization()
            }))
        case .locationServicesEnabled:
            return .search(IgnoredEquatable(.locationServicesEnabled { locationCallback in
                locationRequestHandler.requestLocation(locationCallback)
            }))
        case .locationServicesDisabled:
            return .locationServicesDisabled
        }
    }

}
