//
//  SearchLocationDisabledViewSUI.swift
//  PlacesFinder
//
//  Created by Justin Peckner.
//  Copyright © 2020 Justin Peckner. All rights reserved.
//

import Shared
import SwiftUI

struct SearchLocationDisabledViewSUI: View {

    @ObservedObject private var viewModel: ValueObservable<SearchLocationDisabledViewModel>
    @ObservedObject private var colorings: ValueObservable<SearchCTAViewColorings>

    init(viewModel: SearchLocationDisabledViewModel,
         colorings: SearchCTAViewColorings) {
        self.viewModel = ValueObservable(viewModel)
        self.colorings = ValueObservable(colorings)
    }

    var body: some View {
        SearchCTAViewSUI(viewModel: viewModel.value.ctaViewModel,
                         colorings: colorings.value)
    }

}

extension SearchLocationDisabledViewSUI {

    func configure(_ viewModel: SearchLocationDisabledViewModel,
                   colorings: SearchCTAViewColorings) {
        self.viewModel.value = viewModel
        self.colorings.value = colorings
    }

}
