//
//  StaticInfoView.swift
//  PlacesFinder
//
//  Created by Justin Peckner.
//  Copyright © 2018 Justin Peckner. All rights reserved.
//

import Shared
import SnapKit
import UIKit

class StaticInfoView: UIView {

    let imageView: UIImageView
    let titleLabel: StyledLabel
    let descriptionLabel: StyledLabel

    init(viewModel: StaticInfoViewModel,
         colorings: AppStandardColorings) {
        self.imageView = UIImageView()
        self.titleLabel = StyledLabel()
        self.descriptionLabel = StyledLabel()

        super.init(frame: .zero)

        setupSubviews()
        setupConstraints()
        configure(viewModel,
                  colorings: colorings)
    }

    required init?(coder aDecoder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }

    private func setupSubviews() {
        addSubview(imageView)
        addSubview(titleLabel)
        addSubview(descriptionLabel)
    }

    private func setupConstraints() {
        configureZeroInsetMargins()

        imageView.contentMode = .scaleAspectFit
        imageView.setContentCompressionResistancePriority(.fittingSizeLevel, for: .vertical)
        imageView.snp.makeConstraints { make in
            make.leading.equalTo(snp.leadingMargin)
            make.trailing.equalTo(snp.trailingMargin)
            make.top.equalTo(snp.topMargin)
            make.height.lessThanOrEqualTo(240.0)
        }

        titleLabel.adjustFontSizeToFitWidth()
        titleLabel.setContentHuggingPriority(.required, for: .vertical)
        titleLabel.snp.makeConstraints { make in
            make.leading.equalTo(snp.leadingMargin)
            make.trailing.equalTo(snp.trailingMargin)
            make.top.equalTo(imageView.snp.bottom)
        }

        descriptionLabel.setContentHuggingPriority(.required, for: .vertical)
        descriptionLabel.snp.makeConstraints { make in
            make.leading.equalTo(snp.leadingMargin)
            make.trailing.equalTo(snp.trailingMargin)
            make.top.equalTo(titleLabel.snp.bottom)
            make.bottom.equalTo(snp.bottomMargin)
        }
    }

}

extension StaticInfoView {

    func configure(_ viewModel: StaticInfoViewModel,
                   colorings: AppStandardColoringsProtocol) {
        imageView.image = UIImage(named: viewModel.imageName)

        titleLabel.text = viewModel.title
        titleLabel.configure(.title,
                             textColoring: colorings.titleTextColoring)

        descriptionLabel.text = viewModel.description
        descriptionLabel.configure(.body,
                                   textColoring: colorings.bodyTextColoring)
    }

}
