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

    weak var delegate: SearchLookupViewDelegate?
    private let searchInputView: SearchInputView
    private let inputViewFullHeight: CGFloat
    private let inputViewHeightConstraint: NSLayoutConstraint
    private let childContainerView: SearchChildContainerView

    init(searchInputViewModel: SearchInputViewModel,
         searchInputColorings: SearchInputViewColorings) {
        self.searchInputView = SearchInputView(viewModel: searchInputViewModel,
                                               colorings: searchInputColorings)
        self.inputViewFullHeight = searchInputView.systemLayoutSizeFitting(UIView.layoutFittingCompressedSize).height
        self.inputViewHeightConstraint = searchInputView.heightAnchor.constraint(equalToConstant: inputViewFullHeight)
        inputViewHeightConstraint.isActive = true

        self.childContainerView = SearchChildContainerView()

        super.init(frame: .zero)

        searchInputView.setTextFieldDelegate(self)
        childContainerView.delegate = self
        setupSubviews()
        setupConstraints()
    }

    required init?(coder aDecoder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }

    private func setupSubviews() {
        addSubview(searchInputView)
        addSubview(childContainerView)
    }

    private func setupConstraints() {
        searchInputView.snp.makeConstraints { make in
            make.leading.trailing.top.equalTo(self)
        }

        childContainerView.snp.makeConstraints { make in
            make.leading.trailing.bottom.equalTo(self)
            make.top.equalTo(searchInputView.snp.bottom)
        }
    }

}

extension SearchLookupView: UITextFieldDelegate {

    func textFieldDidBeginEditing(_ textField: UITextField) {
        handleTextFieldEditingState(true)
    }

    func textFieldDidEndEditing(_ textField: UITextField, reason: UITextField.DidEndEditingReason) {
        handleTextFieldEditingState(false)
    }

    func textFieldShouldReturn(_ textField: UITextField) -> Bool {
        textField.resignFirstResponder()

        if let text = textField.text,
            let nonEmptyText = try? NonEmptyString(text) {
            delegate?.searchView(self, didInputText: nonEmptyText)
        } else {
            AssertionHandler.performAssertionFailure { "UITextField should be configured to not return empty text" }
        }

        return true
    }

    private func handleTextFieldEditingState(_ isEditing: Bool) {
        searchInputView.handleTextFieldEditingState(isEditing)
        childContainerView.configureCoverView(isEditing)

        if isEditing {
            inputViewHeightConstraint.constant = inputViewFullHeight
        }
    }

}

extension SearchLookupView: SearchChildContainerViewDelegate {

    func containerViewCoverWasTapped(_ containerView: SearchChildContainerView) {
        searchInputView.resignTextFieldAsFirstResponder()
    }

}

extension SearchLookupView {

    func setChildView(_ childView: UIView) {
        childContainerView.setChildView(childView)
    }

    func configure(_ keywords: NonEmptyString?) {
        searchInputView.configure(keywords)
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
