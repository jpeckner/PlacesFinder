//
//  AppRootCoordinatorMock.swift
//  PlacesFinderTests
//
//  Copyright (c) 2022 Justin Peckner
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
class AppRootCoordinatorMock: RootCoordinatorMock, AppRouterProtocol {

    // MARK: - createSubtree()

    private(set) var createSubtreeCurrentNodeArgValue: NodeBox?
    private(set) var createSubtreeDestinationDescendentArgValue: TDestinationDescendent?
    private(set) var createSubtreeStateArgValue: AppState?

    func createSubtree(from currentNode: NodeBox,
                       towards destinationDescendent: TDestinationDescendent,
                       state: AppState) {
        createSubtreeCurrentNodeArgValue = currentNode
        createSubtreeDestinationDescendentArgValue = destinationDescendent
        createSubtreeStateArgValue = state
    }

    // MARK: - switchSubtree()

    private(set) var switchSubtreeCurrentNodeArgValue: RootCoordinatorMockDescendent?
    private(set) var switchSubtreeDestinationDescendentArgValue: TDestinationDescendent?
    private(set) var switchSubtreeStateArgValue: AppState?

    func switchSubtree(from currentNode: RootCoordinatorMockDescendent,
                       towards destinationDescendent: TDestinationDescendent,
                       state: AppState) {
        switchSubtreeCurrentNodeArgValue = currentNode
        switchSubtreeDestinationDescendentArgValue = destinationDescendent
        switchSubtreeStateArgValue = state
    }

}