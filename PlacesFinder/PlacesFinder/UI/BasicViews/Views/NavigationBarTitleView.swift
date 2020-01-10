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

    init(viewModel: NavigationBarTitleViewModel,
         colorings: NavBarColorings) {
        self.iconImageView = UIImageView(widthConstrainedImage: #imageLiteral(resourceName: "magnifying_glass"))
        self.titleLabel = StyledLabel(textStyleClass: .navBarTitle,
                                      textColoring: colorings.titleTextColoring)

        super.init(frame: .zero)

        setupSubviews()
        setupConstraints()
        setupContent(viewModel)
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

    private func setupContent(_ viewModel: NavigationBarTitleViewModel) {
        titleLabel.text = viewModel.displayName
    }

    private func setupStyling(_ colorings: NavBarColorings) {
        iconImageView.tintColor = colorings.iconTintColoring.color
    }

}

extension UIViewController {

    func configureTitleView(_ viewModel: NavigationBarTitleViewModel,
                            appSkin: AppSkin) {
        navigationItem.titleView = NavigationBarTitleView(viewModel: viewModel,
                                                          colorings: appSkin.colorings.navBar)
    }

}
