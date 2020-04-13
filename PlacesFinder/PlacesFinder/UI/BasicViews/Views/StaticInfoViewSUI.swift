//
//  StaticInfoViewSUI.swift
//  PlacesFinder
//
//  Created by Justin Peckner.
//  Copyright © 2019 Justin Peckner. All rights reserved.
//

import Shared
import SwiftUI

@available(iOS 13.0, *)
struct StaticInfoViewSUI: View {

    private enum Constants {
        static let imageHeight: CGFloat = 240.0
    }

    private let viewModel: StaticInfoViewModel
    private let colorings: AppStandardColorings

    init(viewModel: StaticInfoViewModel,
         colorings: AppStandardColorings) {
        self.viewModel = viewModel
        self.colorings = colorings
    }

    var body: some View {
        VStack {
            Image(viewModel.imageName)
                .resizable()
                .frame(height: Constants.imageHeight,
                       alignment: .center)
                .aspectRatio(contentMode: .fit)

            StyledLabelSUI(text: viewModel.title,
                           styleClass: .title,
                           textColoring: colorings.titleTextColoring)
                .lineLimit(1)
                .allowsTightening(true)

            StyledLabelSUI(text: viewModel.description,
                           styleClass: .body,
                           textColoring: colorings.bodyTextColoring)
                .fixedSize(horizontal: false, vertical: true)
        }
    }

}
