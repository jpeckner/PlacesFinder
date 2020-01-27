//
//  SearchCTAView.swift
//  PlacesFinder
//
//  Created by Justin Peckner.
//  Copyright © 2019 Justin Peckner. All rights reserved.
//

import Shared
import SnapKit
import UIKit

class SearchCTAView: UIView {

    let staticInfoView: StaticInfoView
    let ctaButton: ActionableButton

    init(viewModel: SearchCTAViewModel,
         colorings: SearchCTAViewColorings) {
        self.staticInfoView = StaticInfoView(viewModel: viewModel.infoViewModel,
                                             colorings: colorings)
        self.ctaButton = ActionableButton(touchUpInsideCallback: viewModel.ctaBlock ?? {})

        super.init(frame: .zero)

        setupSubviews()
        setupConstraints()
        configure(viewModel)
        setupStyling(colorings)
    }

    required init?(coder aDecoder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }

    private func setupSubviews() {
        addSubview(staticInfoView)
        addSubview(ctaButton)
    }

    private func setupConstraints() {
        configureMargins(top: 24.0,
                         leading: 16.0,
                         bottom: 8.0,
                         trailing: 16.0)

        staticInfoView.snp.makeConstraints { make in
            make.leading.equalTo(snp.leadingMargin)
            make.trailing.equalTo(snp.trailingMargin)
            make.top.equalTo(snp.topMargin)
        }

        ctaButton.snp.makeConstraints { make in
            make.centerX.equalTo(self)
            make.leading.greaterThanOrEqualTo(snp.leadingMargin)
            make.trailing.lessThanOrEqualTo(snp.trailingMargin)
            make.top.equalTo(staticInfoView.snp.bottom).offset(8.0)
            make.bottom.lessThanOrEqualTo(snp.bottomMargin)
        }
    }

    private func setupStyling(_ colorings: SearchCTAViewColorings) {
        ctaButton.configure(.ctaButton,
                            textColoring: colorings.ctaTextColoring)
    }

}

extension SearchCTAView {

    func configure(_ viewModel: SearchCTAViewModel) {
        staticInfoView.configure(viewModel.infoViewModel)

        if let ctaBlock = viewModel.ctaBlock {
            ctaButton.touchUpInsideCallback = ctaBlock
            ctaButton.setTitle(viewModel.ctaTitle, for: .normal)
            ctaButton.isHidden = false
        } else {
            ctaButton.isHidden = true
        }
    }

}