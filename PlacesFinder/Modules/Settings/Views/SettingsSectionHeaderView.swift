//
//  SettingsSectionHeaderView.swift
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

class SettingsSectionHeaderView: UIView {

    private let label: StyledLabel

    init(viewModel: SettingsPlainHeaderViewModel,
         colorings: SettingsViewColorings) {
        self.label = StyledLabel(textStyleClass: .tableHeader,
                                 textColoring: colorings.headerTextColoring)

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
    }

    private func setupConstraints() {
        configureMargins(top: 8.0,
                         leading: 8.0,
                         bottom: 8.0,
                         trailing: 8.0)

        label.snp.makeConstraints { make in
            make.leading.equalTo(snp.leadingMargin)
            make.trailing.lessThanOrEqualTo(snp.trailingMargin)
            make.top.greaterThanOrEqualTo(snp.topMargin)
            make.bottom.equalTo(snp.bottomMargin)
        }
    }

    private func setupContent(_ viewModel: SettingsPlainHeaderViewModel) {
        label.text = viewModel.title
    }

}
