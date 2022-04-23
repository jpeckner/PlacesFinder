//
//  Search+Redux.swift
//  PlacesFinder
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

import SwiftDux

enum Search {}

extension Search {

    struct State: StateProtocol {
        let searchActivityState: ActivityState
    }

    enum Action: SwiftDux.Action {
        case searchActivity(ActivityAction)
        case receiveState(StateReceiverBlock<Search.State>)
    }

    static func reduce(action: Action,
                       currentState: Search.State) -> Search.State {
        let searchActivityState = reduceSearchAction(action: action,
                                                     currentState: currentState.searchActivityState)

        return State(searchActivityState: searchActivityState)
    }

    private static func reduceSearchAction(action: Action,
                                           currentState: Search.ActivityState) -> Search.ActivityState {
        guard case let .searchActivity(searchActivityAction) = action else {
            return currentState
        }

        return Search.ActivityReducer.reduce(action: searchActivityAction,
                                             currentState: currentState)
    }

    typealias SearchStore = Store<Search.Action, Search.State>

}

extension Search.State {

    init() {
        self.searchActivityState = Search.ActivityState()
    }

}
