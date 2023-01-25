//
//  SearchResultCell.swift
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

class SearchResultCell: SearchCellBase {

    private let thumbnailImageView: DownloadedImageView
    private let ratingStarsView: RatingStarsView
    private let pricingLabel: StyledLabel

    override init(style: UITableViewCell.CellStyle, reuseIdentifier: String?) {
        self.thumbnailImageView = DownloadedImageView(contentMode: .scaleToFill)
        self.ratingStarsView = RatingStarsView()
        self.pricingLabel = StyledLabel()

        super.init(style: style, reuseIdentifier: reuseIdentifier)

        setupThumbnailView()
        setupDetailsView()
    }

    required init?(coder aDecoder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }

    private func setupThumbnailView() {
        thumbnailContainerView.addSubview(thumbnailImageView)
        thumbnailImageView.fitFully(to: thumbnailContainerView)
        thumbnailImageView.contentMode = .scaleAspectFill
    }

    private func setupDetailsView() {
        detailsContainerView.addSubview(ratingStarsView)
        detailsContainerView.addSubview(pricingLabel)

        ratingStarsView.snp.makeConstraints { make in
            make.leading.equalTo(detailsContainerView)
            make.top.bottom.equalTo(detailsContainerView)
        }

        pricingLabel.snp.makeConstraints { make in
            make.leading.greaterThanOrEqualTo(ratingStarsView.snp.trailing).offset(8.0)
            make.trailing.equalTo(detailsContainerView)
            make.top.bottom.equalTo(detailsContainerView)
        }
        pricingLabel.adjustFontSizeToFitWidth()
    }

}

extension SearchResultCell {

    override func prepareForReuse() {
        super.prepareForReuse()

        thumbnailImageView.cancelImageDownload()
    }

}

extension SearchResultCell {

    func configure(_ cellModel: SearchResultCellModel,
                   colorings: SearchResultsViewColorings) {
        thumbnailImageView.configure(cellModel.image)

        nameLabel.text = cellModel.name.value
        nameLabel.configure(.cellText,
                            textColoring: colorings.bodyTextColoring)

        ratingStarsView.configure(cellModel.ratingsAverage)

        pricingLabel.text = cellModel.pricing
        pricingLabel.configure(.pricingLabel,
                               textColoring: colorings.bodyTextColoring)

        disclosureImageView.tintColor = colorings.disclosureArrowTint.color
    }

}
