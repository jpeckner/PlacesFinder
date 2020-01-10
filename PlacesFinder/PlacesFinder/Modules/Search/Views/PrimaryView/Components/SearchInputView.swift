//
//  SearchInputView.swift
//  PlacesFinder
//
//  Created by Justin Peckner.
//  Copyright © 2018 Justin Peckner. All rights reserved.
//

import Shared
import UIKit

class SearchInputView: UIView {

    private let colorings: SearchInputViewColorings
    private let textFieldView: TextFieldView
    private let cancelButton: ActionableButton
    private let cancelButtonLeadingConstraint: NSLayoutConstraint
    private let cancelButtonZeroWidthConstraint: NSLayoutConstraint

    init(viewModel: SearchInputViewModel,
         colorings: SearchInputViewColorings) {
        self.colorings = colorings

        let textFieldView = TextFieldView(colorings: colorings)
        self.textFieldView = textFieldView

        self.cancelButton = ActionableButton { textFieldView.textField.resignFirstResponder() }
        self.cancelButtonLeadingConstraint =
            cancelButton.leadingAnchor.constraint(equalTo: textFieldView.trailingAnchor)
        self.cancelButtonZeroWidthConstraint = cancelButton.widthAnchor.constraint(equalToConstant: 0.0)

        super.init(frame: .zero)

        setupSubviews()
        setupConstraints()
        configure(viewModel)
        setupStyling(colorings)
        setupTextFieldViewTapRecognizer()
    }

    required init?(coder aDecoder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }

    private func setupSubviews() {
        addSubview(textFieldView)
        addSubview(cancelButton)
    }

    // 999 vertical constraint priorities in this method are needed to avoid conflicts when SearchInputView
    // collapses/expands during table scrolling.
    private func setupConstraints() {
        configureMargins(top: 8.0,
                         leading: 8.0,
                         bottom: 8.0,
                         trailing: 8.0)

        textFieldView.snp.makeConstraints { make in
            make.leading.equalTo(snp.leadingMargin)
            make.top.equalTo(snp.topMargin).priority(999)
            make.bottom.equalTo(snp.bottomMargin).priority(999)
        }

        cancelButton.setContentHuggingPriority(.required, for: .horizontal)
        cancelButton.snp.makeConstraints { make in
            make.trailing.equalTo(snp.trailingMargin)
            make.top.equalTo(snp.topMargin).priority(999)
            make.bottom.equalTo(snp.bottomMargin).priority(999)
        }
        cancelButtonZeroWidthConstraint.isActive = true
        cancelButtonLeadingConstraint.isActive = true
    }

    private func setupStyling(_ colorings: SearchInputViewColorings) {
        backgroundColor = colorings.viewColoring.backgroundColor

        cancelButton.configure(.ctaButton, textColoring: colorings.cancelButtonTextColoring)
    }

    private func setupTextFieldViewTapRecognizer() {
        textFieldView.addTarget(self,
                                action: #selector(textFieldViewWasTapped),
                                for: .touchUpInside)
    }

    @objc
    private func textFieldViewWasTapped() {
        guard !textFieldView.textField.isFirstResponder else { return }

        textFieldView.textField.becomeFirstResponder()
    }

}

extension SearchInputView {

    func configure(_ viewModel: SearchInputViewModel) {
        textFieldView.textField.text = viewModel.inputKeywords?.value
        textFieldView.textField.attributedPlaceholder = NSAttributedString(
            string: viewModel.placeholder,
            attributes: [.foregroundColor: colorings.placeholderColoring.textColor]
        )

        cancelButton.setTitle(viewModel.cancelButtonTitle, for: .normal)
    }

    func setTextFieldDelegate(_ delegate: UITextFieldDelegate) {
        textFieldView.textField.delegate = delegate
    }

    func resignTextFieldAsFirstResponder() {
        textFieldView.textField.resignFirstResponder()
    }

}

extension SearchInputView {

    func handleTextFieldEditingState(_ isEditing: Bool) {
        // swiftlint:disable trailing_closure
        UIView.animate(
            withDuration: 0.3,
            delay: 0.0,
            options: [.curveEaseIn],
            animations: { [weak self] in
                self?.cancelButtonLeadingConstraint.constant = isEditing ? 8.0 : 0.0
                self?.cancelButtonZeroWidthConstraint.isActive = !isEditing
            }
        )
        // swiftlint:enable trailing_closure
    }

}

private class TextFieldView: UIControl {

    let iconImageView: UIImageView
    let textField: UITextField

    init(colorings: SearchInputViewColorings) {
        self.iconImageView = UIImageView(widthConstrainedImage: #imageLiteral(resourceName: "magnifying_glass"))
        self.textField = UITextField(frame: .zero)

        super.init(frame: .zero)

        setupSubviews()
        setupConstraints()
        setupStyling(colorings)
        setupTextFieldProperties()
    }

    required init?(coder aDecoder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }

    private func setupSubviews() {
        addSubview(iconImageView)
        addSubview(textField)
    }

    private func setupConstraints() {
        configureMargins(top: 4.0,
                         leading: 8.0,
                         bottom: 4.0,
                         trailing: 8.0)

        iconImageView.contentMode = .scaleAspectFit
        iconImageView.snp.makeConstraints { make in
            make.leading.equalTo(snp.leadingMargin)
            make.top.bottom.equalTo(textField)
        }

        textField.setContentHuggingPriority(.required, for: .vertical)
        textField.snp.makeConstraints { make in
            make.leading.equalTo(iconImageView.snp.trailing).offset(8.0)
            make.trailing.equalTo(snp.trailingMargin)
            make.top.equalTo(snp.topMargin)
            make.bottom.equalTo(snp.bottomMargin)
        }
    }

    private func setupStyling(_ colorings: SearchInputViewColorings) {
        iconImageView.tintColor = colorings.iconTintColoring.color

        textField.backgroundColor = .clear
        textField.configure(.textInput,
                            textColoring: colorings.inputTextColoring)

        backgroundColor = colorings.textFieldViewColoring.backgroundColor
        layer.cornerRadius = 4.0
    }

    private func setupTextFieldProperties() {
        textField.returnKeyType = .go
        textField.enablesReturnKeyAutomatically = true
        textField.clearButtonMode = .whileEditing
    }

}
