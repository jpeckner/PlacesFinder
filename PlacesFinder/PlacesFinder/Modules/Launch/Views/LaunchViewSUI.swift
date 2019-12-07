//
//  LaunchViewSUI.swift
//  PlacesFinder
//
//  Created by Justin Peckner.
//  Copyright © 2019 Justin Peckner. All rights reserved.
//

import Shared
import SwiftUI

@available(iOS 13.0.0, *)
struct LaunchViewSUI: View {

    private enum Constants {
        static let image = #imageLiteral(resourceName: "app_icon")
        static let imageWidthPercentage: CGFloat = 0.3
        static let maxImageWidth: CGFloat = 200.0
        static let maxImageHeight: CGFloat = maxImageWidth
    }

    @ObservedObject var viewModel = LaunchViewModel()
    let colorings: LaunchViewColorings

    var body: some View {
        return GeometryReader { metrics in
            VStack {
                Color.clear.frame(height: metrics.size.height * 0.25)
                    .padding(.top, 0.0)

                self.buildImage(metrics)

                Color.clear.frame(height: metrics.size.height * 0.15)

                ActivityIndicator(_isAnimating: self.$viewModel.isAnimating,
                                  style: .whiteLarge,
                                  color: self.colorings.spinnerColor.color)
            }

            Spacer()
        }
    }

    private func buildImage(_ metrics: GeometryProxy) -> some View {
        let idealWidth = min(metrics.size.width * Constants.imageWidthPercentage,
                             Constants.maxImageWidth)
        let maxWidth = Constants.maxImageWidth
        let idealHeight = idealWidth / Constants.image.widthToHeightRatio
        let maxHeight = maxWidth / Constants.image.widthToHeightRatio

        return Image(uiImage: Constants.image)
            .resizable()
            .frame(idealWidth: idealWidth,
                   maxWidth: maxWidth,
                   idealHeight: idealHeight,
                   maxHeight: maxHeight)
            .fixedSize()
    }

}

@available(iOS 13.0.0, *)
extension LaunchViewSUI: LaunchViewProtocol {

    func startSpinner() {
        self.viewModel.isAnimating = true
    }

    func animateOut(_ completion: (() -> Void)?) {
        self.viewModel.isAnimating = false
        completion?()
    }

}
