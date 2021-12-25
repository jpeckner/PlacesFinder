//
//  SearchInstructionsView.swift
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

extension SearchInstructionsView {

    func configure(_ viewModel: SearchInstructionsViewModel,
                   colorings: AppStandardColorings) {
        staticInfoView.configure(viewModel.infoViewModel,
                                 colorings: colorings)
        resultsSourceView.configure(viewModel)
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
        configure(viewModel)
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

}

private extension ResultsSourceView {

    func configure(_ viewModel: SearchInstructionsViewModel) {
        label.text = viewModel.resultsSource
    }

}
