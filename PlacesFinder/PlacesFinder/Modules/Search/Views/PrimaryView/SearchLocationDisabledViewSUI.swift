//
//  SearchLocationDisabledViewSUI.swift
//  PlacesFinder
//
//  Created by Justin Peckner.
//  Copyright © 2020 Justin Peckner. All rights reserved.
//

import Shared
import SwiftUI

@available(iOS 13.0, *)
struct SearchLocationDisabledViewSUI: View {

    @ObservedObject var viewModel: ValueObservable<SearchLocationDisabledViewModel>
    @ObservedObject var colorings: ValueObservable<SearchCTAViewColorings>

    init(viewModel: SearchLocationDisabledViewModel,
         colorings: SearchCTAViewColorings) {
        self.viewModel = ValueObservable(value: viewModel)
        self.colorings = ValueObservable(value: colorings)
    }

    var body: some View {
        SearchCTAViewSUI(viewModel: viewModel.value.ctaViewModel,
                         colorings: colorings.value)
    }

}
