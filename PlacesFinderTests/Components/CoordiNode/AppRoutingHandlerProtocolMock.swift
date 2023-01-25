//
//  AppRoutingHandlerProtocolMock.swift
//  PlacesFinderTests
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

import CoordiNode
import CoordiNodeTestComponents

// swiftlint:disable identifier_name
// swiftlint:disable large_tuple
// swiftlint:disable line_length
internal class AppRoutingHandlerProtocolMock: AppRoutingHandlerProtocol {

    // MARK: - determineRouting<TRouter: RouterProtocol>

    internal var determineRoutingUpdatedSubstatesRouterCallsCount = 0
    internal var determineRoutingUpdatedSubstatesRouterCalled: Bool {
        return determineRoutingUpdatedSubstatesRouterCallsCount > 0
    }
    internal var determineRoutingUpdatedSubstatesRouterReceivedArguments: (state: AppState, updatedSubstates: Set<PartialKeyPath<AppState>>, router: CoordinatorProtocol)?
    internal var determineRoutingUpdatedSubstatesRouterClosure: ((AppState, Set<PartialKeyPath<AppState>>, CoordinatorProtocol) -> Void)?

    internal func determineRouting<TRouter: RouterProtocol>(_ state: AppState,
                                                            updatedSubstates: Set<PartialKeyPath<AppState>>,
                                                            router: TRouter) {
        determineRoutingUpdatedSubstatesRouterCallsCount += 1
        determineRoutingUpdatedSubstatesRouterReceivedArguments = (state: state, updatedSubstates: updatedSubstates, router: router)
        determineRoutingUpdatedSubstatesRouterClosure?(state, updatedSubstates, router)
    }

}
