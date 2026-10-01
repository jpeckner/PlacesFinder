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

    typealias ViewModel = SinglePropsViewModel<SearchLookupProps>

    @Environment(\.colorScheme) var colorScheme

    private let viewModel: ViewModel
    private let searchBar: UISearchBar
    private let actionTriggered: (Search.Action) -> Void

    init(viewModel: ViewModel,
         searchBar: UISearchBar,
         actionTriggered: @escaping (Search.Action) -> Void) {
        self.viewModel = viewModel
        self.searchBar = searchBar
        self.actionTriggered = actionTriggered
    }

    var body: some View {
        VStack(spacing: .zero) {
            SearchLookupSearchBar(
                props: viewModel.props.inputProps.content,
                searchBar: searchBar
            )

            ZStack {
                childView
                    .ignoresSafeArea(.keyboard, edges: .bottom)

                coverView
                    .ignoresSafeArea()
            }
        }
    }

    @ViewBuilder
    private var childView: some View {
        switch viewModel.props.child {
        case let .instructions(props):
            SearchInstructionsView(props: props)

        case let .progress(props):
            SearchProgressView(props: props)

        case let .results(props):
            SearchResultsView(
                props: props,
                actionTriggered: actionTriggered
            )

        case let .noResults(props):
            StaticInfoView<AppStandardColorings>(props: props.messageViewProps.props)

        case let .failure(props):
            SearchCTAView(props: props.ctaViewProps)
        }
    }

    @ViewBuilder
    private var coverView: some View {
        switch viewModel.props.inputProps.content.barState.isEditing {
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
                    actionTriggered(viewModel.props.inputProps.coverTappedAction.value)
                }

        case false:
            EmptyView()
        }
    }

}
