//
//  SearchLookupParentView.swift
//  PlacesFinder
//
//  Copyright (c) 2023 Justin Peckner
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

struct SearchLookupParentView: View {

    @Environment(\.colorScheme) var colorScheme

    @ObservedObject var viewModel: ValueObservable<SearchLookupViewModel>
    private let searchBar: UISearchBar

    init(viewModel: SearchLookupViewModel,
         searchBar: UISearchBar) {
        self.viewModel = ValueObservable(viewModel)
        self.searchBar = searchBar
    }

    var body: some View {
        VStack(spacing: .zero) {
            SearchLookupSearchBar(
                viewModel: viewModel.value.searchInputViewModel.content,
                searchBar: searchBar
            )

            ZStack {
                childView

                coverView
            }
            .ignoresSafeArea(.keyboard, edges: .bottom)
        }
    }

    @ViewBuilder
    private var childView: some View {
        switch viewModel.value.child {
        case let .instructions(viewModel):
            SearchInstructionsView(viewModel: viewModel)

        case let .progress(viewModel):
            SearchProgressView(viewModel: viewModel)

        case let .results(viewModel):
            SearchResultsView(viewModel: viewModel)

        case let .noResults(viewModel):
            StaticInfoView<AppStandardColorings>(viewModel: viewModel.messageViewModel.infoViewModel)

        case let .failure(viewModel):
            SearchCTAView(viewModel: viewModel.ctaViewModel)
        }
    }

    @ViewBuilder
    private var coverView: some View {
        switch viewModel.value.searchInputViewModel.content.barState.isEditing {
        case true:
            let coverColor: Color = {
                switch colorScheme {
                case .light:
                    return Color.black

                case .dark:
                    return Color.white

                @unknown default:
                    AssertionHandler.performAssertionFailure { "Unknown enum value: \(colorScheme)" }
                    return Color.black
                }
            }()

            coverColor
                .opacity(0.3)
                .onTapGesture {
                    viewModel.value.searchInputViewModel.coverTappedCallback?()
                }

        case false:
            EmptyView()
        }
    }

}
