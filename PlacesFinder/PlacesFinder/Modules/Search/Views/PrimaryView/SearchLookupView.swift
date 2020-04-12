//
//  SearchLookupView.swift
//  PlacesFinder
//
//  Created by Justin Peckner.
//  Copyright © 2019 Justin Peckner. All rights reserved.
//

import Shared
import UIKit

class SearchLookupView: UIView {

    private let searchBarWrapper: SearchBarWrapper
    private let childContainerView: SearchChildContainerView
    private var inputViewModel: SearchInputViewModel

    var searchBarWrapperView: UIView {
        return searchBarWrapper.view
    }

    init(inputViewModel: SearchInputViewModel,
         searchInputColorings: SearchInputViewColorings) {
        self.inputViewModel = inputViewModel
        self.searchBarWrapper = SearchBarWrapper()
        self.childContainerView = SearchChildContainerView(coverTappedCallback: inputViewModel.coverTappedCallback)

        super.init(frame: .zero)

        searchBarWrapper.delegate = self
        setupSubviews()
        setupConstraints()
        configure(inputViewModel,
                  colorings: searchInputColorings)
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

    func configure(_ inputViewModel: SearchInputViewModel,
                   colorings: SearchInputViewColorings) {
        self.inputViewModel = inputViewModel

        searchBarWrapper.configureText(inputViewModel.content.keywords?.value)
        searchBarWrapper.configurePlaceholder(inputViewModel.content.placeholder)

        childContainerView.configureCoverView(inputViewModel.content.isEditing)
        searchBarWrapper.isFirstResponder = inputViewModel.content.isEditing

        UITextField.appearance(whenContainedInInstancesOf: [UISearchBar.self]).defaultTextAttributes.updateValue(
            AppTextStyleClass.textInput.textLayout.font,
            forKey: .font
        )
    }

    func setChildView(_ childView: UIView) {
        childContainerView.setChildView(childView)
    }

}

extension SearchLookupView: SearchBarWrapperDelegate {

    func searchBarWrapper(_ searchBarWrapper: SearchBarWrapper, didPerformEvent event: SearchBarEditEvent) {
        inputViewModel.dispatcher?.dispatchEditEvent(event)
    }

    func searchBarWrapper(_ searchBarWrapper: SearchBarWrapper, didClickSearch text: NonEmptyString) {
        let params = SearchParams(keywords: text)
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
                dispatcher.dispatchEditEvent(.endedEditing)
            }
        }
    }

    var dispatcher: SearchInputDispatcher? {
        switch self {
        case .nonDispatching:
            return nil
        case let .dispatching(_, dispatcher):
            return dispatcher
        }
    }

}
