//
//  SearchMessageView.swift
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

class SearchMessageView: UIView {

    private let staticInfoView: StaticInfoView

    init(viewModel: SearchMessageViewModel,
         colorings: AppStandardColorings) {
        self.staticInfoView = StaticInfoView(viewModel: viewModel.infoViewModel,
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
            make.bottom.lessThanOrEqualTo(snp.bottomMargin)
        }
    }

}

extension SearchMessageView {

    func configure(_ viewModel: SearchMessageViewModel,
                   colorings: AppStandardColorings) {
        staticInfoView.configure(viewModel.infoViewModel,
                                 colorings: colorings)
    }

}
