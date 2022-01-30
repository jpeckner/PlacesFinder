//
//  StaticInfoView.swift
//  PlacesFinder
//
//  Copyright (c) 2018 Justin Peckner
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

class StaticInfoView: UIView {

    let imageView: UIImageView
    let titleLabel: StyledLabel
    let descriptionLabel: StyledLabel

    init(viewModel: StaticInfoViewModel,
         colorings: AppStandardColoringsProtocol) {
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
            make.height.greaterThanOrEqualTo(160.0)
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
