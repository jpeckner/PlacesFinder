//
//  SearchCTAViewSUI.swift
//  PlacesFinder
//
//  Created by Justin Peckner.
//  Copyright © 2019 Justin Peckner. All rights reserved.
//

import SwiftUI

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
            StaticInfoViewSUI(viewModel: viewModel.infoViewModel,
                              colorings: colorings.standard)
                .padding(.bottom)

            viewModel.ctaBlock.map {
                Button(action: $0.value) {
                    Text(viewModel.ctaTitle)
                }
                .configure(.ctaButton,
                           textColoring: colorings.ctaTextColoring)
            }
        }
        .padding()
    }

}
