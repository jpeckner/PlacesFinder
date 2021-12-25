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

// swiftlint:disable identifier_name
// swiftlint:disable large_tuple
// swiftlint:disable line_length
internal class AppRoutingHandlerProtocolMock: AppRoutingHandlerProtocol {

    // MARK: - handleRouting<TRouter: RouterProtocol>

    internal var handleRoutingUpdatedSubstatesRouterCallsCount = 0
    internal var handleRoutingUpdatedSubstatesRouterCalled: Bool {
        return handleRoutingUpdatedSubstatesRouterCallsCount > 0
    }
    internal var handleRoutingUpdatedSubstatesRouterReceivedArguments: (state: AppState, updatedSubstates: Set<PartialKeyPath<AppState>>, router: CoordinatorProtocol)?
    internal var handleRoutingUpdatedSubstatesRouterClosure: ((AppState, Set<PartialKeyPath<AppState>>, CoordinatorProtocol) -> Void)?

    internal func handleRouting<TRouter: RouterProtocol>(_ state: AppState,
                                                         updatedSubstates: Set<PartialKeyPath<AppState>>,
                                                         router: TRouter) {
        handleRoutingUpdatedSubstatesRouterCallsCount += 1
        handleRoutingUpdatedSubstatesRouterReceivedArguments = (state: state, updatedSubstates: updatedSubstates, router: router)
        handleRoutingUpdatedSubstatesRouterClosure?(state, updatedSubstates, router)
    }

}
