//
//  SearchInstructionsView.swift
//  PlacesFinder
//
//  Created by Justin Peckner.
//  Copyright © 2019 Justin Peckner. All rights reserved.
//

import Shared
import UIKit

class SearchInstructionsView: UIView {

    private let staticInfoView: StaticInfoView
    private let resultsSourceView: ResultsSourceView

    init(viewModel: SearchInstructionsViewModel,
         colorings: AppStandardColorings) {
        self.staticInfoView = StaticInfoView(viewModel: viewModel.infoViewModel,
                                             colorings: colorings)
        self.resultsSourceView = ResultsSourceView(viewModel: viewModel,
                                                   colorings: colorings)

        super.init(frame: .zero)

        setupSubviews()
        setupConstraints()
    }

    required init?(coder aDecoder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }

    private func setupSubviews() {
        addSubview(staticInfoView)
        addSubview(resultsSourceView)
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

        resultsSourceView.snp.makeConstraints { make in
            make.centerX.equalTo(self)
            make.leading.greaterThanOrEqualTo(snp.leadingMargin)
            make.trailing.lessThanOrEqualTo(snp.trailingMargin)
            make.top.equalTo(staticInfoView.snp.bottom)
            make.bottom.lessThanOrEqualTo(snp.bottomMargin)
        }
    }

}

private class ResultsSourceView: UIView {

    private let label: StyledLabel
    private let logoView: APILogoView

    init(viewModel: SearchInstructionsViewModel,
         colorings: AppStandardColorings) {
        self.label = StyledLabel(textStyleClass: .sourceAPILabel,
                                 textColoring: colorings.bodyTextColoring)
        self.logoView = APILogoView(viewColoring: colorings.viewColoring)

        super.init(frame: .zero)

        setupSubviews()
        setupConstraints()
        setupContent(viewModel)
    }

    required init?(coder aDecoder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }

    private func setupSubviews() {
        addSubview(label)
        addSubview(logoView)
    }

    private func setupConstraints() {
        label.setContentHuggingPriority(.required, for: .vertical)
        label.snp.makeConstraints { make in
            make.leading.equalTo(self)
            make.centerY.equalTo(self).offset(2.0)
            make.top.greaterThanOrEqualTo(self)
            make.bottom.lessThanOrEqualTo(self)
        }

        logoView.snp.makeConstraints { make in
            make.leading.equalTo(label.snp.trailing)
            make.trailing.top.bottom.equalTo(self)
            make.width.equalTo(APILogoView.minWidth)
        }
    }

    private func setupContent(_ viewModel: SearchInstructionsViewModel) {
        label.text = viewModel.resultsSourceCopy
    }

}
