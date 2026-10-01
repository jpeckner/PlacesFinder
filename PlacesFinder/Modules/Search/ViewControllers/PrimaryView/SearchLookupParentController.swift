//
//  SearchLookupParentController.swift
//  PlacesFinder
//
//  Copyright (c) 2018 Justin Peckner
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
import SwiftUI

class SearchLookupParentController: UIHostingController<SearchLookupParentView>, SearchPrimaryViewControllerProtocol {

    private let eventPublisher = SearchBarEventPublisher()
    private var cancellables: Set<AnyCancellable> = []

    private let propsViewModel: SearchLookupParentView.ViewModel
    private let viewModel: SearchViewModel

    init(
        props: SearchLookupProps,
        viewModel: SearchViewModel
    ) {
        let propsViewModel = SearchLookupParentView.ViewModel(props: props)
        self.propsViewModel = propsViewModel
        self.viewModel = viewModel

        let searchBar = UISearchBar()
        searchBar.configureWithDefaults()
        searchBar.delegate = eventPublisher

        let lookupView = SearchLookupParentView(
            viewModel: propsViewModel,
            searchBar: searchBar
        ) { [weak viewModel] searchAction in
            viewModel?.dispatchAction(searchAction)
        }

        super.init(rootView: lookupView)

        subscribeToSearchEvents()
    }

    required init?(coder aDecoder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }

}

extension SearchLookupParentController {

    func configure(props: SearchLookupProps) {
        propsViewModel.props = props
    }

}

private extension SearchLookupParentController {

    func subscribeToSearchEvents() {
        eventPublisher.eventPublisher
            .sink { [weak self] event in
                self?.handleSearchBarEvent(event: event)
            }
            .store(in: &cancellables)

        eventPublisher.searchBarSubmitPublisher
            .sink { [weak self] searchText in
                self?.handleSearchBarSubmit(text: searchText)
            }
            .store(in: &cancellables)
    }

    func handleSearchBarEvent(event: SearchBarEditEvent) {
        viewModel.dispatchEditEvent(event)
    }

    func handleSearchBarSubmit(text: String?) {
        guard let text = text,
            !text.isEmpty
        else {
            AssertionHandler.performAssertionFailure { "UISearchBar should be configured to not return nil text" }
            viewModel.dispatchEditEvent(.endedEditing)
            return
        }

        guard let nonEmptyText = try? NonEmptyString(text.trimmingCharacters(in: .whitespacesAndNewlines)) else {
            viewModel.dispatchEditEvent(.endedEditing)
            return
        }

        let params = SearchParams(keywords: nonEmptyText)
        viewModel.dispatchSearchParams(params)
    }

}
