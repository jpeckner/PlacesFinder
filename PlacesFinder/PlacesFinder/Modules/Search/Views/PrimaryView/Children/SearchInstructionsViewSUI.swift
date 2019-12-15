//
//  SearchInstructionsViewSUI.swift
//  PlacesFinder
//
//  Created by Justin Peckner.
//  Copyright © 2019 Justin Peckner. All rights reserved.
//

import Shared
import SwiftUI

@available(iOS 13.0.0, *)
struct SearchInstructionsViewSUI: View {

    private let viewModel: SearchInstructionsViewModel
    private let colorings: AppStandardColorings

    init(viewModel: SearchInstructionsViewModel, colorings: AppStandardColorings) {
        self.viewModel = viewModel
        self.colorings = colorings
    }

    var body: some View {
        VStack {
            StaticInfoViewSUI(viewModel: viewModel.infoViewModel)
                .padding()

            ResultsSourceViewSUI(viewModel: viewModel, colorings: colorings)
                .padding()
        }
    }

}

@available(iOS 13.0.0, *)
private struct ResultsSourceViewSUI: View {

    private enum Constants {
        static let imageWidth: CGFloat = 64.0
    }

    let viewModel: SearchInstructionsViewModel
    let colorings: AppStandardColorings

    var body: some View {
        HStack(spacing: 0.0) {
            StyledLabelSUI(text: viewModel.resultsSourceCopy,
                           styleClass: .sourceAPILabel,
                           textColoring: colorings.bodyTextColoring)
                .padding(.top, 3.0)

            Image(uiImage: apiLogo)
                .resizable()
                .frame(width: Constants.imageWidth,
                       height: Constants.imageWidth / apiLogo.widthToHeightRatio)
        }
    }

    private var apiLogo: UIImage {
        return colorings.viewColoring.apiLogo
    }

}
