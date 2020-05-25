//
//  SearchCTAViewSUI.swift
//  PlacesFinder
//
//  Created by Justin Peckner.
//  Copyright © 2019 Justin Peckner. All rights reserved.
//

import Shared
import SwiftUI

struct SearchCTAViewSUI: View {

    @ObservedObject private var viewModel: ValueObservable<SearchCTAViewModel>
    @ObservedObject private var colorings: ValueObservable<SearchCTAViewColorings>

    init(viewModel: SearchCTAViewModel,
         colorings: SearchCTAViewColorings) {
        self.viewModel = ValueObservable(viewModel)
        self.colorings = ValueObservable(colorings)
    }

    var body: some View {
        VStack {
            StaticInfoViewSUI(viewModel: viewModel.value.infoViewModel,
                              colorings: colorings.value.standard)
                .padding(.bottom)

            viewModel.value.ctaBlock.map {
                Button(action: $0.value) {
                    Text(viewModel.value.ctaTitle)
                }
                .configure(.ctaButton,
                           textColoring: colorings.value.ctaTextColoring)
            }
        }
        .padding()
    }

}

extension SearchCTAViewSUI {

    func configure(_ viewModel: SearchCTAViewModel,
                   colorings: SearchCTAViewColorings) {
        self.viewModel.value = viewModel
        self.colorings.value = colorings
    }

}
