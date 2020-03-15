//
//  SearchLookupView.swift
//  PlacesFinder
//
//  Created by Justin Peckner.
//  Copyright © 2019 Justin Peckner. All rights reserved.
//

import Shared
import UIKit

protocol SearchLookupViewDelegate: AnyObject {
    func searchView(_ searchView: SearchLookupView, didInputText text: NonEmptyString)
}

class SearchLookupView: UIView {

    private enum TextEditState {
        case notEditing
        case editing(previous: String?)
        case exitedWithReturn
    }

    weak var delegate: SearchLookupViewDelegate?
    private let searchBar: UISearchBar
    private let inputViewFullHeight: CGFloat
    private let inputViewHeightConstraint: NSLayoutConstraint
    private let childContainerView: SearchChildContainerView
    private var editState: TextEditState

    init(searchInputViewModel: SearchInputViewModel,
         searchInputColorings: SearchInputViewColorings) {
        self.searchBar = UISearchBar()
        searchBar.returnKeyType = .go
        searchBar.enablesReturnKeyAutomatically = true

        self.inputViewFullHeight = searchBar.systemLayoutSizeFitting(UIView.layoutFittingCompressedSize).height
        self.inputViewHeightConstraint = searchBar.heightAnchor.constraint(equalToConstant: inputViewFullHeight)
        inputViewHeightConstraint.isActive = true

        self.childContainerView = SearchChildContainerView()

        self.editState = .notEditing

        super.init(frame: .zero)

        searchBar.delegate = self
        childContainerView.delegate = self
        setupSubviews()
        setupConstraints()
        setupStyling(searchInputColorings)
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

    private func setupStyling(_ colorings: SearchInputViewColorings) {
        UITextField.appearance(whenContainedInInstancesOf: [UISearchBar.self]).defaultTextAttributes.updateValue(
            AppTextStyleClass.textInput.textLayout.font,
            forKey: .font
        )
    }

}

extension SearchLookupView: UISearchBarDelegate {

    func searchBarTextDidBeginEditing(_ searchBar: UISearchBar) {
        editState = .editing(previous: searchBar.text)
        handleTextFieldEditingState(true)
    }

    func searchBarTextDidEndEditing(_ searchBar: UISearchBar) {
        switch editState {
        case let .editing(previous):
            searchBar.text = previous
        case .exitedWithReturn:
            break
        case .notEditing:
            AssertionHandler.performAssertionFailure { "Unexpected editState value: \(editState)" }
        }

        editState = .notEditing
        handleTextFieldEditingState(false)
    }

    func searchBarSearchButtonClicked(_ searchBar: UISearchBar) {
        editState = .exitedWithReturn
        searchBar.resignFirstResponder()

        if let text = searchBar.text,
            let nonEmptyText = try? NonEmptyString(text) {
            delegate?.searchView(self, didInputText: nonEmptyText)
        } else {
            AssertionHandler.performAssertionFailure { "UISearchBar should be configured to not return empty text" }
        }
    }

    private func handleTextFieldEditingState(_ isEditing: Bool) {
        childContainerView.configureCoverView(isEditing)

        if isEditing {
            inputViewHeightConstraint.constant = inputViewFullHeight
        }
    }

}

extension SearchLookupView: SearchChildContainerViewDelegate {

    func containerViewCoverWasTapped(_ containerView: SearchChildContainerView) {
        searchBar.resignFirstResponder()
    }

}

extension SearchLookupView {

    func configure(_ viewModel: SearchInputViewModel,
                   colorings: SearchInputViewColorings) {
        searchBar.text = viewModel.searchParams?.keywords.value
        searchBar.placeholder = viewModel.placeholder
    }

    func setChildView(_ childView: UIView) {
        childContainerView.setChildView(childView)
    }

}

extension SearchLookupView {

    func childTableDidScroll(_ deltaY: CGFloat) {
        let updatedHeight = deltaY > 0 ?
            // Prevent setting constant < 0
            max(0.0, inputViewHeightConstraint.constant - deltaY)
            // Prevent setting constant > inputViewOriginalHeight
            : min(inputViewFullHeight, inputViewHeightConstraint.constant - deltaY)

        inputViewHeightConstraint.constant = updatedHeight
    }

}
