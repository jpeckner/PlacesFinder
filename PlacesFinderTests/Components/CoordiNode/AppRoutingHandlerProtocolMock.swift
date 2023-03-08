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

    // MARK: - determineRouting<TRouter: AppRouterProtocol>

    var determineRoutingUpdatedRoutingSubstatesRouterCallsCount = 0
    var determineRoutingUpdatedRoutingSubstatesRouterCalled: Bool {
        return determineRoutingUpdatedRoutingSubstatesRouterCallsCount > 0
    }
    var determineRoutingUpdatedRoutingSubstatesRouterReceivedArguments: (state: AppState, updatedRoutingSubstates: UpdatedRoutingSubstates, router: any AppRouterProtocol)?
    var determineRoutingUpdatedRoutingSubstatesRouterReceivedInvocations: [(state: AppState, updatedRoutingSubstates: UpdatedRoutingSubstates, router: any AppRouterProtocol)] = []
    var determineRoutingUpdatedRoutingSubstatesRouterClosure: ((AppState, UpdatedRoutingSubstates, any AppRouterProtocol) -> Void)?

    @MainActor
    func determineRouting<TRouter: AppRouterProtocol>(state: AppState, updatedRoutingSubstates: UpdatedRoutingSubstates, router: TRouter) {
        determineRoutingUpdatedRoutingSubstatesRouterCallsCount += 1
        determineRoutingUpdatedRoutingSubstatesRouterReceivedArguments = (state: state, updatedRoutingSubstates: updatedRoutingSubstates, router: router)
        determineRoutingUpdatedRoutingSubstatesRouterReceivedInvocations.append((state: state, updatedRoutingSubstates: updatedRoutingSubstates, router: router))
        determineRoutingUpdatedRoutingSubstatesRouterClosure?(state, updatedRoutingSubstates, router)
    }

    // MARK: - determineRouting<TDestRouter: AppDestinationRouterProtocol>

    var determineDestRoutingUpdatedRoutingSubstatesRouterCallsCount = 0
    var determineDestRoutingUpdatedRoutingSubstatesRouterCalled: Bool {
        return determineDestRoutingUpdatedRoutingSubstatesRouterCallsCount > 0
    }
    var determineDestRoutingUpdatedRoutingSubstatesRouterReceivedArguments: (state: AppState, updatedRoutingSubstates: UpdatedRoutingSubstates, router: any AppDestinationRouterProtocol)?
    var determineDestRoutingUpdatedRoutingSubstatesRouterReceivedInvocations: [(state: AppState, updatedRoutingSubstates: UpdatedRoutingSubstates, router: any AppDestinationRouterProtocol)] = []
    var determineDestRoutingUpdatedRoutingSubstatesRouterClosure: ((AppState, UpdatedRoutingSubstates, any AppDestinationRouterProtocol) -> Void)?

    @MainActor
    func determineRouting<TDestRouter: AppDestinationRouterProtocol>(state: AppState, updatedRoutingSubstates: UpdatedRoutingSubstates, router: TDestRouter) {
        determineDestRoutingUpdatedRoutingSubstatesRouterCallsCount += 1
        determineDestRoutingUpdatedRoutingSubstatesRouterReceivedArguments = (state: state, updatedRoutingSubstates: updatedRoutingSubstates, router: router)
        determineDestRoutingUpdatedRoutingSubstatesRouterReceivedInvocations.append((state: state, updatedRoutingSubstates: updatedRoutingSubstates, router: router))
        determineDestRoutingUpdatedRoutingSubstatesRouterClosure?(state, updatedRoutingSubstates, router)
    }

}
