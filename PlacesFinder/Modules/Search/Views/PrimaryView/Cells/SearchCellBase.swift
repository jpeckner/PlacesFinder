//
//  SearchCellBase.swift
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
