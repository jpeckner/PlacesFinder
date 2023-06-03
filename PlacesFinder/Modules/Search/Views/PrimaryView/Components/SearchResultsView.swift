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

    @ObservedObject var viewModel: ValueObservable<SearchResultsViewModel>

    init(viewModel: SearchResultsViewModel) {
        self.viewModel = ValueObservable(viewModel)
    }

    var body: some View {
        List(viewModel.value.resultViewModels.value.indexed, id: \.element.cellModel.id) { index, resultViewModel in
            Button(
                action: {
                    viewModel.value.dispatchDetailsAction(rowIndex: index)
                },
                label: {
                    SearchResultCell(cellModel: ValueObservable(resultViewModel.cellModel))
                        .onAppear {
                            dispatchRequestIfApplicable(currentIndex: index)
                        }
                }
            )
        }
        .listStyle(PlainListStyle())
        .showVerticalScrollIndicatorsiOS16Min(false)
        .refreshable {
            // Add a slight delay to keep the refresh control from disappearing too fast (which is jarring)
            DispatchQueue.main.asyncAfter(deadline: .now() + 0.5) {
                viewModel.value.dispatchRefreshAction()
            }
        }
    }

    private func dispatchRequestIfApplicable(currentIndex: Int) {
        guard viewModel.value.hasNextRequestAction,
              currentIndex >= viewModel.value.resultViewModels.value.count - 30
        else {
            return
        }

        viewModel.value.dispatchNextRequestAction()
    }

}
