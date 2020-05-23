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

    @ObservedObject var viewModel: ValueObservable<SearchLocationDisabledViewModel>
    @ObservedObject var colorings: ValueObservable<SearchCTAViewColorings>

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
