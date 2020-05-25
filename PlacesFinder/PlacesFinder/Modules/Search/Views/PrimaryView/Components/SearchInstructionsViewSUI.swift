//
//  SearchInstructionsViewSUI.swift
//  PlacesFinder
//
//  Created by Justin Peckner.
//  Copyright © 2019 Justin Peckner. All rights reserved.
//

import Shared
import SwiftUI

struct SearchInstructionsViewSUI: View {

    @ObservedObject private var viewModel: ValueObservable<SearchInstructionsViewModel>
    @ObservedObject private var colorings: ValueObservable<AppStandardColorings>

    init(viewModel: SearchInstructionsViewModel,
         colorings: AppStandardColorings) {
        self.viewModel = ValueObservable(viewModel)
        self.colorings = ValueObservable(colorings)
    }

    var body: some View {
        VStack {
            StaticInfoViewSUI(viewModel: viewModel.value.infoViewModel,
                              colorings: colorings.value)
                .padding()

            ResultsSourceViewSUI(viewModel: viewModel.value,
                                 colorings: colorings.value)
                .padding()
        }
    }

}

extension SearchInstructionsViewSUI {

    func configure(_ viewModel: SearchInstructionsViewModel,
                   colorings: AppStandardColorings) {
        self.viewModel.value = viewModel
        self.colorings.value = colorings
    }

}

private struct ResultsSourceViewSUI: View {

    private enum Constants {
        static let imageWidth: CGFloat = 64.0
    }

    let viewModel: SearchInstructionsViewModel
    let colorings: AppStandardColorings

    var body: some View {
        HStack(spacing: 0.0) {
            StyledLabelSUI(text: viewModel.resultsSource,
                           styleClass: .sourceAPILabel,
                           textColoring: colorings.bodyTextColoring)
                .padding(.top, 3.0)

            Image(uiImage: APILogoConstants.logoImage)
                .resizable()
                .frame(width: Constants.imageWidth,
                       height: Constants.imageWidth / APILogoConstants.logoImage.widthToHeightRatio)
        }
    }

}
