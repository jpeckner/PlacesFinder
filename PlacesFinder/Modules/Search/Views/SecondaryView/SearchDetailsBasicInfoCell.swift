//
//  SearchDetailsBasicInfoCell.swift
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

class SearchDetailsBasicInfoCell: UITableViewCell {

    private let mainImageView: DownloadedImageView
    private let infoContentView: InfoContentView
    private let ratingsPricingView: RatingsPricingView

    override init(style: UITableViewCell.CellStyle, reuseIdentifier: String?) {
        self.mainImageView = DownloadedImageView()
        self.infoContentView = InfoContentView()
        self.ratingsPricingView = RatingsPricingView()

        super.init(style: style, reuseIdentifier: reuseIdentifier)

        setupSubviews()
        setupConstraints()
        setupStyling()
    }

    required init?(coder aDecoder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }

    private func setupSubviews() {
        contentView.addSubview(mainImageView)
        contentView.addSubview(infoContentView)
        contentView.addSubview(ratingsPricingView)
    }

    private func setupConstraints() {
        preservesSuperviewLayoutMargins = false
        configureZeroInsetMargins()
        contentView.configureMargins(top: 8.0,
                                     leading: 8.0,
                                     bottom: 8.0,
                                     trailing: 8.0)

        mainImageView.contentMode = .scaleToFill
        mainImageView.snp.makeConstraints { make in
            make.centerX.equalTo(contentView)
            make.leading.equalTo(contentView.snp.leadingMargin).priority(999)
            make.trailing.equalTo(contentView.snp.trailingMargin).priority(999)
            make.top.equalTo(contentView.snp.topMargin)

            make.width.lessThanOrEqualTo(400.0)
            make.height.equalTo(mainImageView.snp.width)
        }

        infoContentView.snp.makeConstraints { make in
            make.centerX.equalTo(contentView)
            make.leading.greaterThanOrEqualTo(contentView.snp.leadingMargin).priority(999)
            make.trailing.lessThanOrEqualTo(contentView.snp.trailingMargin).priority(999)
            make.top.equalTo(mainImageView.snp.bottom).offset(8.0)
        }

        ratingsPricingView.snp.makeConstraints { make in
            make.centerX.equalTo(contentView)
            make.leading.greaterThanOrEqualTo(contentView.snp.leadingMargin).priority(999)
            make.trailing.lessThanOrEqualTo(contentView.snp.trailingMargin).priority(999)
            make.top.equalTo(infoContentView.snp.bottom).offset(16.0)
            make.bottom.equalTo(contentView.snp.bottomMargin)
        }
    }

    private func setupStyling() {
        mainImageView.layer.cornerRadius = 4.0
        mainImageView.layer.masksToBounds = true
    }

}

extension SearchDetailsBasicInfoCell {

    func configure(_ viewModel: SearchDetailsBasicInfoViewModel,
                   colorings: SearchDetailsViewColorings) {
        mainImageView.configure(viewModel.image)

        infoContentView.configure(viewModel,
                                  colorings: colorings)

        ratingsPricingView.configure(viewModel,
                                     colorings: colorings)
    }

}

// MARK: InfoContentView

private class InfoContentView: UIView {

    private let nameLabel: StyledLabel
    private let addressLabel: StyledLabel

    init() {
        self.nameLabel = StyledLabel()
        self.addressLabel = StyledLabel()

        super.init(frame: .zero)

        setupSubviews()
        setupConstraints()
    }

    required init?(coder aDecoder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }

    private func setupSubviews() {
        addSubview(nameLabel)
        addSubview(addressLabel)
    }

    private func setupConstraints() {
        nameLabel.setContentCompressionResistancePriority(.required, for: .vertical)
        nameLabel.adjustFontSizeToFitWidth()
        nameLabel.snp.makeConstraints { make in
            make.leading.trailing.top.equalTo(self)
        }

        addressLabel.setContentCompressionResistancePriority(.required, for: .vertical)
        addressLabel.snp.makeConstraints { make in
            make.leading.trailing.bottom.equalTo(self)
            make.top.equalTo(nameLabel.snp.bottom)
        }
    }

}

extension InfoContentView {

    func configure(_ viewModel: SearchDetailsBasicInfoViewModel,
                   colorings: SearchDetailsViewColorings) {
        nameLabel.text = viewModel.name.value
        nameLabel.configure(.subtitle,
                            textColoring: colorings.bodyTextColoring)

        addressLabel.text = viewModel.address?.value
        addressLabel.configure(.body,
                               textColoring: colorings.bodyTextColoring)
    }

}

// MARK: RatingsPricingView

private class RatingsPricingView: UIView {

    private let ratingStarsView: RatingStarsView
    private let numRatingsLabel: StyledLabel
    private let pricingLabel: StyledLabel
    private let apiLinkButton: UIButton

    private var apiLinkCallback: OpenURLBlock?

    init() {
        self.ratingStarsView = RatingStarsView()
        self.numRatingsLabel = StyledLabel()
        self.pricingLabel = StyledLabel()
        self.apiLinkButton = UIButton()

        super.init(frame: .zero)

        setupSubviews()
        setupConstraints()
        setupTapHandler()
    }

    required init?(coder aDecoder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }

    private func setupSubviews() {
        addSubview(ratingStarsView)
        addSubview(numRatingsLabel)
        addSubview(pricingLabel)
        addSubview(apiLinkButton)
    }

    private func setupConstraints() {
        ratingStarsView.snp.makeConstraints { make in
            make.leading.top.equalTo(self)
        }

        numRatingsLabel.snp.makeConstraints { make in
            make.leading.bottom.equalTo(self)
            make.top.equalTo(ratingStarsView.snp.bottom).offset(8.0)
        }

        pricingLabel.snp.makeConstraints { make in
            make.leading.greaterThanOrEqualTo(numRatingsLabel).offset(-8.0)
            make.trailing.equalTo(ratingStarsView)
            make.bottom.equalTo(self)
            make.top.equalTo(numRatingsLabel)
        }

        apiLinkButton.snp.makeConstraints { make in
            make.leading.equalTo(ratingStarsView.snp.trailing).offset(40.0)
            make.trailing.equalTo(self)
            make.centerY.equalTo(self)
            make.top.greaterThanOrEqualTo(self)
            make.bottom.lessThanOrEqualTo(self)

            make.width.equalTo(100.0)
            make.width.equalTo(apiLinkButton.snp.height).multipliedBy(APILogoView.widthToHeightRatio)
        }
    }

    private func setupTapHandler() {
        apiLinkButton.addTarget(self,
                                action: #selector(apiLinkButtonWasTapped),
                                for: .touchUpInside)
    }

    @objc
    private func apiLinkButtonWasTapped() {
        apiLinkCallback?()
    }

}

extension RatingsPricingView {

    func configure(_ viewModel: SearchDetailsBasicInfoViewModel,
                   colorings: SearchDetailsViewColorings) {
        ratingStarsView.configure(viewModel.ratingsAverage)

        numRatingsLabel.text = viewModel.numRatingsMessage
        numRatingsLabel.configure(.body,
                                  textColoring: colorings.bodyTextColoring)
        numRatingsLabel.textAlignment = .left

        pricingLabel.text = viewModel.pricing
        pricingLabel.configure(.body,
                               textColoring: colorings.bodyTextColoring)
        pricingLabel.textAlignment = .right

        apiLinkButton.setImage(colorings.viewColoring.apiLogo, for: .normal)
        apiLinkCallback = viewModel.apiLinkCallback?.value
    }

}
