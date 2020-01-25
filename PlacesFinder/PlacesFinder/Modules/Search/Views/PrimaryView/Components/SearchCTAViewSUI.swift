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
    private let ctaBlock: SearchCTABlock

    init(viewModel: SearchCTAViewModel,
         colorings: SearchCTAViewColorings,
         ctaBlock: @escaping SearchCTABlock) {
        self.viewModel = viewModel
        self.colorings = colorings
        self.ctaBlock = ctaBlock
    }

    var body: some View {
        VStack {
            StaticInfoViewSUI(viewModel: viewModel.infoViewModel)
                .padding(.bottom)

            Button(action: ctaBlock) {
                Text(viewModel.ctaTitle)
            }
            .configure(.ctaButton, textColoring: colorings.ctaTextColoring)
        }.padding()
    }

}
