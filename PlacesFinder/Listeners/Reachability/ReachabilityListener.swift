//
//  ReachabilityListener.swift
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

import Combine
import Shared
import SwiftDux

protocol ReachabilityListenerProtocol: AutoMockable {
    var actionPublisher: AnyPublisher<Action, Never> { get }

    func start() throws
}

class ReachabilityListener: ReachabilityListenerProtocol {

    var actionPublisher: AnyPublisher<Action, Never> {
        subject.eraseToAnyPublisher()
    }

    private let reachability: ReachabilityProtocol
    private let subject = PassthroughSubject<Action, Never>()

    init(reachability: ReachabilityProtocol) {
        self.reachability = reachability
    }

    func start() throws {
        reachability.setReachabilityCallback { [weak self] status in
            switch status {
            case .unreachable:
                self?.subject.send(ReachabilityAction.unreachable)
            case let .reachable(connectionType):
                self?.subject.send(ReachabilityAction.reachable(connectionType))
            }
        }

        try reachability.startNotifier()
    }

}
