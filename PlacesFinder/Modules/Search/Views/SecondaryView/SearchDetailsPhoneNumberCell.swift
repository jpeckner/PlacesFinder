//
//  SearchDetailsPhoneNumberCell.swift
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

class SearchDetailsPhoneNumberCell: UITableViewCell {

    private let iconImageView: UIImageView
    private let phoneNumberLabel: StyledLabel
    private let disclosureImageView: UIImageView

    private var tapCallback: OpenURLBlock?

    override init(style: UITableViewCell.CellStyle, reuseIdentifier: String?) {
        self.iconImageView = UIImageView(widthConstrainedImage: #imageLiteral(resourceName: "phone"))
        self.phoneNumberLabel = StyledLabel()
        self.disclosureImageView = UIImageView(widthConstrainedImage: #imageLiteral(resourceName: "right_arrow").withRenderingMode(.alwaysTemplate))

        super.init(style: style, reuseIdentifier: reuseIdentifier)

        setupSubviews()
        setupConstraints()
    }

    required init?(coder aDecoder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }

    private func setupSubviews() {
        contentView.addSubview(iconImageView)
        contentView.addSubview(phoneNumberLabel)
        contentView.addSubview(disclosureImageView)
    }

    private func setupConstraints() {
        contentView.configureMargins(top: 8.0,
                                     leading: 8.0,
                                     bottom: 8.0,
                                     trailing: 8.0)

        iconImageView.contentMode = .scaleAspectFit
        iconImageView.snp.makeConstraints { make in
            make.leading.equalTo(contentView.snp.leadingMargin)
            make.top.equalTo(phoneNumberLabel)
            make.bottom.equalTo(phoneNumberLabel)
        }

        phoneNumberLabel.numberOfLines = 1
        phoneNumberLabel.setContentHuggingPriority(.required, for: .vertical)
        phoneNumberLabel.snp.makeConstraints { make in
            make.leading.equalTo(iconImageView.snp.trailing).offset(20.0)
            make.trailing.equalTo(contentView.snp.trailingMargin)
            make.top.equalTo(contentView.snp.topMargin)
            make.bottom.equalTo(contentView.snp.bottomMargin)
        }

        disclosureImageView.contentMode = .scaleAspectFit
        disclosureImageView.snp.makeConstraints { make in
            make.trailing.equalTo(contentView.snp.trailingMargin)
            make.centerY.equalTo(contentView)
            make.top.greaterThanOrEqualTo(contentView.snp.topMargin)
            make.bottom.lessThanOrEqualTo(contentView.snp.bottomMargin)
            make.height.equalTo(24.0)
        }
    }

}

extension SearchDetailsPhoneNumberCell {

    func configure(_ viewModel: SearchDetailsPhoneNumberViewModel,
                   colorings: SearchDetailsViewColorings) {
        iconImageView.tintColor = colorings.phoneIconTint.color

        phoneNumberLabel.text = viewModel.phoneLabelText
        phoneNumberLabel.configure(.body,
                                   textColoring: colorings.bodyTextColoring)
        phoneNumberLabel.textAlignment = .left

        tapCallback = viewModel.makeCallBlock?.value
        disclosureImageView.isHidden = tapCallback == nil
        disclosureImageView.tintColor = colorings.disclosureArrowTint.color
    }

    func executeTapCallback() {
        tapCallback?()
    }

}
