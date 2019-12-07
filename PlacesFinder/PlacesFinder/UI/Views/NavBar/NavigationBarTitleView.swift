//
//  NavigationBarTitleView.swift
//  PlacesFinder
//
//  Created by Justin Peckner.
//  Copyright © 2019 Justin Peckner. All rights reserved.
//

import Shared
import SnapKit
import UIKit

class NavigationBarTitleView: UIView {

    private let iconImageView: UIImageView
    private let titleLabel: StyledLabel

    init(appCopyContent: AppCopyContent,
         colorings: NavBarColorings) {
        self.iconImageView = UIImageView(widthConstrainedImage: #imageLiteral(resourceName: "magnifying_glass"))
        self.titleLabel = StyledLabel(textStyleClass: .navBarTitle,
                                      textColoring: colorings.titleTextColoring)

        super.init(frame: .zero)

        setupSubviews()
        setupConstraints()
        setupContent(appCopyContent)
        setupStyling(colorings)
    }

    required init?(coder aDecoder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }

    private func setupSubviews() {
        addSubview(iconImageView)
        addSubview(titleLabel)
    }

    private func setupConstraints() {
        iconImageView.contentMode = .scaleAspectFit
        iconImageView.snp.makeConstraints { make in
            make.leading.top.bottom.equalTo(self)
        }

        titleLabel.adjustFontSizeToFitWidth()
        titleLabel.snp.makeConstraints { make in
            make.leading.equalTo(iconImageView.snp.trailing).offset(8.0)
            make.trailing.top.bottom.equalTo(self)
        }
    }

    private func setupContent(_ appCopyContent: AppCopyContent) {
        titleLabel.text = appCopyContent.displayName.value
    }

    private func setupStyling(_ colorings: NavBarColorings) {
        iconImageView.tintColor = colorings.iconTintColoring.color
    }

}
