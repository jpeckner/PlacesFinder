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

    let searchBar: UISearchBar
    let childContainerView: SearchChildContainerView

    init(searchInputViewModel: SearchInputViewModel,
         searchInputColorings: SearchInputViewColorings) {
        self.searchBar = UISearchBar()
        searchBar.returnKeyType = .go
        searchBar.enablesReturnKeyAutomatically = true

        self.childContainerView = SearchChildContainerView()

        super.init(frame: .zero)

        setupSubviews()
        setupConstraints()
        configure(searchInputViewModel,
                  colorings: searchInputColorings)
    }

    required init?(coder aDecoder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }

    private func setupSubviews() {
        addSubview(searchBar)
        addSubview(childContainerView)
    }

    private func setupConstraints() {
        searchBar.snp.makeConstraints { make in
            make.leading.trailing.top.equalTo(self)
        }

        childContainerView.snp.makeConstraints { make in
            make.leading.trailing.bottom.equalTo(self)
            make.top.equalTo(searchBar.snp.bottom)
        }
    }

}

extension SearchLookupView {

    func configure(_ viewModel: SearchInputViewModel,
                   colorings: SearchInputViewColorings) {
        searchBar.text = viewModel.searchParams?.keywords.value
        searchBar.placeholder = viewModel.placeholder

        UITextField.appearance(whenContainedInInstancesOf: [UISearchBar.self]).defaultTextAttributes.updateValue(
            AppTextStyleClass.textInput.textLayout.font,
            forKey: .font
        )
    }

    func setChildView(_ childView: UIView) {
        childContainerView.setChildView(childView)
    }

}
