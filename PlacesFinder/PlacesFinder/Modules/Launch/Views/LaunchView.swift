//
//  LaunchView.swift
//  PlacesFinder
//
//  Created by Justin Peckner.
//  Copyright © 2019 Justin Peckner. All rights reserved.
//

import SnapKit
import UIKit

class LaunchView: UIView {

    private let topPaddingView: UIView
    private let imageView: UIImageView
    private let centerYPaddingView: UIView
    private let activityIndicator: UIActivityIndicatorView

    init(colorings: LaunchViewColorings) {
        self.topPaddingView = UIView()
        self.imageView = UIImageView(image: #imageLiteral(resourceName: "app_icon"))
        self.centerYPaddingView = UIView()
        self.activityIndicator = UIActivityIndicatorView(style: .whiteLarge)

        super.init(frame: .zero)

        setupSubviews()
        setupConstraints()
        setupStyling(colorings)
    }

    required init?(coder aDecoder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }

    private func setupSubviews() {
        addSubview(topPaddingView)
        addSubview(imageView)
        addSubview(centerYPaddingView)
        addSubview(activityIndicator)
    }

    private func setupConstraints() {
        topPaddingView.snp.makeConstraints { make in
            make.leading.trailing.top.equalTo(self)
            make.height.equalTo(self).multipliedBy(0.25)
        }

        imageView.snp.makeConstraints { make in
            make.centerX.equalTo(self)
            make.top.equalTo(topPaddingView.snp.bottom)

            make.width.equalTo(self).multipliedBy(0.3).priority(999)
            make.width.lessThanOrEqualTo(200.0)
            make.height.equalTo(imageView.snp.width)
        }

        centerYPaddingView.snp.makeConstraints { make in
            make.leading.trailing.equalTo(self)
            make.top.equalTo(self.snp.centerY)
            make.height.equalTo(self).multipliedBy(0.15)
        }

        activityIndicator.snp.makeConstraints { make in
            make.centerX.equalTo(self)
            make.top.equalTo(centerYPaddingView.snp.bottom)

            make.width.equalTo(self).multipliedBy(0.125).priority(999)
            make.width.lessThanOrEqualTo(88.0)
            make.height.equalTo(activityIndicator.snp.width)
        }
    }

    private func setupStyling(_ colorings: LaunchViewColorings) {
        imageView.contentMode = .scaleAspectFit

        activityIndicator.color = colorings.spinnerColor
        activityIndicator.hidesWhenStopped = true
    }

}

extension LaunchView {

    func startSpinner() {
        activityIndicator.startAnimating()
    }

    func animateOut(_ completion: (() -> Void)?) {
        activityIndicator.stopAnimating()

        performImageTightentingAnimation(completion)
    }

    private func performImageTightentingAnimation(_ allAnimationsComplete: (() -> Void)?) {
        UIView.animate(
            withDuration: 0.3,
            delay: 0.0,
            options: [.curveLinear],
            animations: {
                self.imageView.transform = CGAffineTransform(scaleX: 0.7, y: 0.7)
            },
            completion: { _ in
                self.performImageExpansionAnimation(allAnimationsComplete)
            }
        )
    }

    private func performImageExpansionAnimation(_ allAnimationsComplete: (() -> Void)?) {
        UIView.animate(
            withDuration: 0.2,
            delay: 0.0,
            options: [.curveEaseIn],
            animations: {
                self.imageView.transform = CGAffineTransform(scaleX: 10, y: 10)
                self.imageView.alpha = 0.0
            },
            completion: { _ in
                allAnimationsComplete?()
            }
        )
    }

}
