//
//  SearchViewModel.swift
//  PlacesFinder
//
//  Copyright (c) 2026 Justin Peckner
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

class SearchViewModel {
    private let inputs: Inputs

    init(actionSubscriber: AnySubscriber<Search.Action, Never>,
         actionPrism: SearchActivityActionPrismProtocol,
         locationUpdateRequestBlock: @escaping LocationUpdateRequestBlock) {
        self.inputs = Inputs(actionSubscriber: actionSubscriber,
                             actionPrism: actionPrism,
                             locationUpdateRequestBlock: locationUpdateRequestBlock)
    }
}

extension SearchViewModel {

    struct Inputs {
        let actionSubscriber: AnySubscriber<Search.Action, Never>
        let actionPrism: SearchActivityActionPrismProtocol
        let locationUpdateRequestBlock: LocationUpdateRequestBlock
    }

}

extension SearchViewModel {

    func dispatchAction(_ action: Search.Action) {
        _ = inputs.actionSubscriber.receive(action)
    }

    func dispatchEditEvent(_ editEvent: SearchBarEditEvent) {
        let action = inputs.actionPrism.updateEditingAction(editEvent)
        _ = inputs.actionSubscriber.receive(.searchActivity(action))
    }

    func dispatchSearchParams(_ params: SearchParams) {
        let action = inputs.actionPrism.initialRequestAction(
            searchParams: params,
            locationUpdateRequestBlock: inputs.locationUpdateRequestBlock
        )
        _ = inputs.actionSubscriber.receive(.searchActivity(action))
    }

}
