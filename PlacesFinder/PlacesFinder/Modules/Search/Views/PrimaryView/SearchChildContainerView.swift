//
//  SearchChildContainerView.swift
//  PlacesFinder
//
//  Created by Justin Peckner.
//  Copyright © 2019 Justin Peckner. All rights reserved.
//

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
        configureCoverView(false)
        setupTapHandler()
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
        childView.removeFromSuperview()
        addSubview(newChildView)
        newChildView.fitFully(to: self)
        childView = newChildView

        let coverBackgroundColor = newChildView.backgroundColor.map { $0.isLight ? .black : .white } ?? UIColor.black
        coverView.backgroundColor = coverBackgroundColor.withAlphaComponent(0.3)
    }

    func configureCoverView(_ showCoverView: Bool) {
        bringSubviewToFront(showCoverView ? coverView : childView)
    }

}
