//
//  LaunchViewSUI.swift
//  PlacesFinder
//
//  Created by Justin Peckner.
//  Copyright © 2019 Justin Peckner. All rights reserved.
//

import Shared
import SwiftUI

// NOTE: this view is unused until SwiftUI supports chained animations (see LaunchView.swift for desired animations).
struct LaunchViewSUI: View {

    private enum Constants {
        static let image = #imageLiteral(resourceName: "app_icon")
    }

    @ObservedObject private var viewModel: LaunchViewModelObservable
    private let colorings: LaunchViewColorings

    var body: some View {
        GeometryReader { metrics in
            VStack {
                Color.clear.frame(height: metrics.size.height * 0.25)
                    .padding(.top, 0.0)

                Image(uiImage: Constants.image)
                    .resizable()
                    .frame(width: min(metrics.size.width * 0.3, 200.0),
                           widthToHeightRatio: Constants.image.widthToHeightRatio)

                Color.clear.frame(height: metrics.size.height * 0.15)

                ActivityIndicator(_isAnimating: self.$viewModel.isAnimating,
                                  style: .large,
                                  color: self.colorings.spinnerColor.color)
            }

            Spacer()
        }
    }

}

extension LaunchViewSUI: LaunchViewProtocol {

    func startSpinner() {
        self.viewModel.isAnimating = true
    }

    func animateOut(_ completion: (() -> Void)?) {
        self.viewModel.isAnimating = false
        completion?()
    }

}
