//
//  SearchDetailsPhoneNumberCell.swift
//  PlacesFinder
//
//  Created by Justin Peckner.
//  Copyright © 2019 Justin Peckner. All rights reserved.
//

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
