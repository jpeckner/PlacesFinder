//
//  SearchChildContainerView.swift
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
import SnapKit
import UIKit

class SearchChildContainerView: UIView {

    private let coverTappedCallback: (() -> Void)?
    private let coverView: UIControl
    private var childView: UIView

    init(coverTappedCallback: (() -> Void)?) {
        self.coverTappedCallback = coverTappedCallback
        self.coverView = UIControl()
        self.childView = UIView()

        super.init(frame: .zero)

        setupSubviews()
        setupTapHandler()
        configureCoverView(false)
    }

    required init?(coder aDecoder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }

    private func setupSubviews() {
        addSubview(coverView)
        coverView.fitFully(to: self)
    }

    private func setupTapHandler() {
        coverView.addTarget(self,
                            action: #selector(coverViewWasTapped),
                            for: .touchUpInside)
    }

    @objc
    private func coverViewWasTapped() {
        coverTappedCallback?()
    }

}

extension SearchChildContainerView {

    func setChildView(_ newChildView: UIView) {
        guard newChildView !== childView else {
            return
        }

        childView.removeFromSuperview()
        addSubview(newChildView)
        newChildView.fitFully(to: self)
        childView = newChildView
    }

    func configureCoverView(_ showCoverView: Bool) {
        let coverBackgroundColor = childView.backgroundColor.map { $0.isLight ? .black : .white } ?? UIColor.black
        coverView.backgroundColor = coverBackgroundColor.withAlphaComponent(0.3)

        bringSubviewToFront(showCoverView ? coverView : childView)
    }

}
