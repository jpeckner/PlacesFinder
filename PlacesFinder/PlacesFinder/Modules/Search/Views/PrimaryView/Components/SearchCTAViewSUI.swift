//
//  SearchCTAViewSUI.swift
//  PlacesFinder
//
//  Created by Justin Peckner.
//  Copyright © 2019 Justin Peckner. All rights reserved.
//

import SwiftUI

@available(iOS 13.0, *)
struct SearchCTAViewSUI: View {

    private let viewModel: SearchCTAViewModel
    private let colorings: SearchCTAViewColorings

    init(viewModel: SearchCTAViewModel,
         colorings: SearchCTAViewColorings) {
        self.viewModel = viewModel
        self.colorings = colorings
    }

    var body: some View {
        VStack {
            StaticInfoViewSUI(viewModel: viewModel.infoViewModel, colorings: colorings.standard)
                .padding(.bottom)

            viewModel.ctaBlock.map {
                Button(action: $0) {
                    Text(viewModel.ctaTitle)
                }
                .configure(.ctaButton, textColoring: colorings.ctaTextColoring)
            }
        }
        .padding()
    }

}
