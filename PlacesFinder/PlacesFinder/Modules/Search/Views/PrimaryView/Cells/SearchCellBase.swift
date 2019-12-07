//
//  SearchCellBase.swift
//  PlacesFinder
//
//  Created by Justin Peckner.
//  Copyright © 2019 Justin Peckner. All rights reserved.
//

import Shared
import SnapKit
import UIKit

class SearchCellBase: UITableViewCell {

    let thumbnailContainerView: UIView
    let nameLabel: StyledLabel
    let detailsContainerView: UIView
    let disclosureImageView: UIImageView

    override init(style: UITableViewCell.CellStyle, reuseIdentifier: String?) {
        self.thumbnailContainerView = UIView()
        self.nameLabel = StyledLabel()
        self.detailsContainerView = UIView()
        self.disclosureImageView = UIImageView(widthConstrainedImage: #imageLiteral(resourceName: "right_arrow").withRenderingMode(.alwaysTemplate))

        super.init(style: style, reuseIdentifier: reuseIdentifier)

        setupSubviews()
        setupConstraints()
        setupStyling()
    }

    required init?(coder aDecoder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }

    private func setupSubviews() {
        contentView.addSubview(thumbnailContainerView)
        contentView.addSubview(nameLabel)
        contentView.addSubview(detailsContainerView)
        contentView.addSubview(disclosureImageView)
    }

    private func setupConstraints() {
        preservesSuperviewLayoutMargins = false
        configureZeroInsetMargins()
        contentView.configureMargins(top: 8.0,
                                     leading: 8.0,
                                     bottom: 8.0,
                                     trailing: 8.0)

        thumbnailContainerView.snp.makeConstraints { make in
            make.leading.equalTo(contentView.snp.leadingMargin)
            make.top.equalTo(contentView.snp.topMargin)
            make.bottom.equalTo(contentView.snp.bottomMargin)
            make.width.equalTo(64.0)
            make.height.equalTo(thumbnailContainerView.snp.width).priority(999)
        }

        nameLabel.adjustFontSizeToFitWidth()
        nameLabel.snp.makeConstraints { make in
            make.leading.equalTo(thumbnailContainerView.snp.trailing).offset(8.0)
            make.trailing.equalTo(disclosureImageView.snp.leading).offset(-16.0)
            make.top.equalTo(contentView.snp.topMargin)
        }

        detailsContainerView.snp.makeConstraints { make in
            make.leading.equalTo(nameLabel)
            make.trailing.equalTo(nameLabel).priority(999)
            make.top.greaterThanOrEqualTo(nameLabel.snp.bottom).offset(8.0)
            make.bottom.equalTo(thumbnailContainerView)
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

    private func setupStyling() {
        thumbnailContainerView.layer.cornerRadius = 4.0
        thumbnailContainerView.layer.masksToBounds = true
    }

}
