//
//  SearchResultCell.swift
//  PlacesFinder
//
//  Created by Justin Peckner.
//  Copyright © 2019 Justin Peckner. All rights reserved.
//

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
        thumbnailImageView.configureImage(cellModel.image)

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
