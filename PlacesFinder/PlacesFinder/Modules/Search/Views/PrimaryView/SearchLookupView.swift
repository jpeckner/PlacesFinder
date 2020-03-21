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

    var searchBarWrapperView: UIView {
        return searchBarWrapper.view
    }

    init(contentViewModel: SearchInputContentViewModel,
         searchInputColorings: SearchInputViewColorings,
         coverTappedCallback: (() -> Void)?) {
        self.searchBarWrapper = SearchBarWrapper()

        self.childContainerView = SearchChildContainerView(coverTappedCallback: coverTappedCallback)

        super.init(frame: .zero)

        setupSubviews()
        setupConstraints()
        configure(contentViewModel,
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

    func configure(_ viewModel: SearchInputContentViewModel,
                   colorings: SearchInputViewColorings) {
        searchBarWrapper.configureText(viewModel.keywords?.value)
        searchBarWrapper.configurePlaceholder(viewModel.placeholder)

        childContainerView.configureCoverView(viewModel.isEditing)
        searchBarWrapper.isFirstResponder = viewModel.isEditing

        UITextField.appearance(whenContainedInInstancesOf: [UISearchBar.self]).defaultTextAttributes.updateValue(
            AppTextStyleClass.textInput.textLayout.font,
            forKey: .font
        )
    }

    func setSearchBarWrapperDelegate(_ delegate: SearchBarWrapperDelegate) {
        searchBarWrapper.delegate = delegate
    }

    func setChildView(_ childView: UIView) {
        childContainerView.setChildView(childView)
    }

}
