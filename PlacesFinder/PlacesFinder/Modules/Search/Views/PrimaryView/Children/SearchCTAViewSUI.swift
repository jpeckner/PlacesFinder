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
    private let retryBlock: SearchCTARetryBlock

    init(viewModel: SearchCTAViewModel,
         colorings: SearchCTAViewColorings,
         retryBlock: @escaping SearchCTARetryBlock) {
        self.viewModel = viewModel
        self.colorings = colorings
        self.retryBlock = retryBlock
    }

    var body: some View {
        VStack {
            StaticInfoViewSUI(viewModel: viewModel.infoViewModel)
                .padding(.bottom)

            Button(action: retryBlock) {
                Text(viewModel.ctaTitle)
            }
            .configure(.ctaButton, textColoring: colorings.ctaTextColoring)
        }.padding()
    }

}
