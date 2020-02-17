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

    @ObservedObject var viewModel: ValueObservable<SearchInstructionsViewModel>
    @ObservedObject var colorings: ValueObservable<AppStandardColorings>

    init(viewModel: SearchInstructionsViewModel,
         colorings: AppStandardColorings) {
        self.viewModel = ValueObservable(value: viewModel)
        self.colorings = ValueObservable(value: colorings)
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

@available(iOS 13.0.0, *)
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
