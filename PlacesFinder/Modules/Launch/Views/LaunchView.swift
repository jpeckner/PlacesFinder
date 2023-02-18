//
//  LaunchView.swift
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
        self.activityIndicator = UIActivityIndicatorView(style: .large)

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

        activityIndicator.color = colorings.spinnerColor.color
        activityIndicator.hidesWhenStopped = true
    }

}

extension LaunchView {

    func startSpinner() {
        activityIndicator.startAnimating()
    }

    func animateOut() async {
        activityIndicator.stopAnimating()

        await withCheckedContinuation { continuation in
            performImageTightentingAnimation(continuation: continuation)
        }
    }

    private func performImageTightentingAnimation(continuation: CheckedContinuation<Void, Never>) {
        UIView.animate(
            withDuration: 0.3,
            delay: 0.0,
            options: [.curveLinear],
            animations: {
                self.imageView.transform = CGAffineTransform(scaleX: 0.7, y: 0.7)
            },
            completion: { _ in
                self.performImageExpansionAnimation(continuation: continuation)
            }
        )
    }

    private func performImageExpansionAnimation(continuation: CheckedContinuation<Void, Never>) {
        UIView.animate(
            withDuration: 0.2,
            delay: 0.0,
            options: [.curveEaseIn],
            animations: {
                self.imageView.transform = CGAffineTransform(scaleX: 10, y: 10)
                self.imageView.alpha = 0.0
            },
            completion: { _ in
                continuation.resume()
            }
        )
    }

}
