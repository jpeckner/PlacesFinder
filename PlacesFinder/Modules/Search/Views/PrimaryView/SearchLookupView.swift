//
//  SearchLookupView.swift
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
import UIKit

class SearchLookupView: UIView {

    private let searchBarWrapper: SearchBarWrapper
    private let childContainerView: SearchChildContainerView
    private var inputViewModel: SearchInputViewModel

    var searchBarWrapperView: UIView {
        return searchBarWrapper.view
    }

    init(inputViewModel: SearchInputViewModel) {
        self.inputViewModel = inputViewModel
        self.searchBarWrapper = SearchBarWrapper()
        self.childContainerView = SearchChildContainerView(coverTappedCallback: inputViewModel.coverTappedCallback)

        super.init(frame: .zero)

        searchBarWrapper.delegate = self
        setupSubviews()
        setupConstraints()
        configure(inputViewModel)
    }

    required init?(coder aDecoder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }

    private func setupSubviews() {
        addSubview(searchBarWrapperView)
        addSubview(childContainerView)
    }

    private func setupConstraints() {
        searchBarWrapperView.snp.makeConstraints { make in
            make.leading.trailing.top.equalTo(self)
        }

        childContainerView.snp.makeConstraints { make in
            make.leading.trailing.bottom.equalTo(self)
            make.top.equalTo(searchBarWrapperView.snp.bottom)
        }
    }

}

extension SearchLookupView {

    func configure(_ inputViewModel: SearchInputViewModel) {
        self.inputViewModel = inputViewModel

        searchBarWrapper.configureText(inputViewModel.content.keywords?.value)
        searchBarWrapper.configurePlaceholder(inputViewModel.content.placeholder)
        searchBarWrapper.isFirstResponder = inputViewModel.content.isEditing

        childContainerView.configureCoverView(inputViewModel.content.isEditing)
    }

    func setChildView(_ childView: UIView) {
        childContainerView.setChildView(childView)
    }

}

extension SearchLookupView: SearchBarWrapperDelegate {

    func searchBarWrapper(_ searchBarWrapper: SearchBarWrapper, didPerformEvent event: SearchBarEditEvent) {
        inputViewModel.dispatcher?.dispatchEditEvent(event)
    }

    func searchBarWrapper(_ searchBarWrapper: SearchBarWrapper, didClickSearch text: String?) {
        guard let text = text,
            !text.isEmpty
        else {
            AssertionHandler.performAssertionFailure { "UISearchBar should be configured to not return nil text" }
            inputViewModel.dispatcher?.dispatchEditEvent(.endedEditing)
            return
        }

        guard let nonEmptyText = try? NonEmptyString(text.trimmingCharacters(in: .whitespacesAndNewlines)) else {
            inputViewModel.dispatcher?.dispatchEditEvent(.endedEditing)
            return
        }

        let params = SearchParams(keywords: nonEmptyText)
        inputViewModel.dispatcher?.dispatchSearchParams(params)
    }

}

private extension SearchInputViewModel {

    var coverTappedCallback: (() -> Void)? {
        switch self {
        case .nonDispatching:
            return nil
        case let .dispatching(_, dispatcher):
            return {
                dispatcher.value.dispatchEditEvent(.endedEditing)
            }
        }
    }

    var dispatcher: SearchInputDispatcher? {
        switch self {
        case .nonDispatching:
            return nil
        case let .dispatching(_, dispatcher):
            return dispatcher.value
        }
    }

}
