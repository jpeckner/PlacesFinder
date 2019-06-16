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

protocol SearchCTACopyProtocol: StaticInfoCopyProtocol {
    var ctaTitle: String { get }
}

extension SearchCTACopyProtocol {

    var retryViewModel: SearchRetryViewModel {
        return SearchRetryViewModel(infoViewModel: staticInfoViewModel,
                                    ctaTitle: ctaTitle)
    }

}

class SearchCTAView: UIView {

    private let staticInfoView: StaticInfoView
    private let ctaButton: ActionableButton

    init(viewModel: SearchRetryViewModel,
         colorings: SearchCTAViewColorings,
         retryBlock: @escaping () -> Void) {
        self.staticInfoView = StaticInfoView(viewModel: viewModel.infoViewModel,
                                             colorings: colorings)
        self.ctaButton = ActionableButton(touchUpInsideCallback: retryBlock)

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

    private func setupContent(_ viewModel: SearchRetryViewModel) {
        ctaButton.setTitle(viewModel.ctaTitle, for: .normal)
    }

    private func setupStyling(_ colorings: SearchCTAViewColorings) {
        ctaButton.configure(.ctaButton,
                            textColoring: colorings.ctaTextColoring)
    }

}
