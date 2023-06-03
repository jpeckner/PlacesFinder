//
//  NavigationBarTitleView.swift
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
