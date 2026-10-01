//
//  SearchResultsView.swift
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

import Shared
import SwiftUI

struct SearchResultsView: View {

    private let props: SearchResultsViewProps
    private let actionTriggered: (Search.Action) -> Void

    init(
        props: SearchResultsViewProps,
        actionTriggered: @escaping (Search.Action) -> Void
    ) {
        self.props = props
        self.actionTriggered = actionTriggered
    }

    var body: some View {
        List(props.resultProps.value.indexed, id: \.element.cellProps.id) { index, resultProps in
            Button(
                action: {
                    actionTriggered(resultProps.detailEntityAction.value)
                },
                label: {
                    SearchResultCell(props: resultProps.cellProps)
                        .onAppear {
                            dispatchRequestIfApplicable(currentIndex: index)
                        }
                }
            )
        }
        .listStyle(PlainListStyle())
        .scrollIndicators(
            .hidden,
            axes: [.vertical]
        )
        .refreshable {
            // Add a slight delay to keep the refresh control from disappearing too fast (which is jarring)
            DispatchQueue.main.asyncAfter(deadline: .now() + 0.5) {
                actionTriggered(props.refreshAction.value)
            }
        }
    }

    private func dispatchRequestIfApplicable(currentIndex: Int) {
        Task {
            guard currentIndex >= props.resultProps.value.count - 30,
                  // Be sure to call consume() only AFTER determining that currentIndex is high enough.
                  // Otherwise this will consume `nextRequestAction` too early and prevent the next request
                  // from actually happening.
                  let nextRequestAction = await props.nextRequestAction.value.consume()
            else {
                return
            }

            actionTriggered(nextRequestAction)
        }
    }

}
