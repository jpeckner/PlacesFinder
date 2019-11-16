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

    @State var viewModel: SearchCTAViewModelSUI
    let colorings: SearchCTAViewColorings
    let retryBlock: SearchCTARetryBlock

    var body: some View {
        VStack {
            StaticInfoViewSUI(viewModel: $viewModel.infoViewModel)
                .padding(.bottom)

            Button(action: retryBlock) {
                Text(viewModel.ctaTitle)
            }
            .configure(.ctaButton, textColoring: colorings.ctaTextColoring)
        }.padding()
    }

}
