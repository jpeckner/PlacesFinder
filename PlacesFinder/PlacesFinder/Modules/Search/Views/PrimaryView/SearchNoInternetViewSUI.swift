//
//  SearchNoInternetViewSUI.swift
//  PlacesFinder
//
//  Created by Justin Peckner.
//  Copyright © 2020 Justin Peckner. All rights reserved.
//

import Shared
import SwiftUI

struct SearchNoInternetViewSUI: View {

    @ObservedObject private var viewModel: ValueObservable<SearchNoInternetViewModel>
    @ObservedObject private var colorings: ValueObservable<AppStandardColorings>

    init(viewModel: SearchNoInternetViewModel,
         colorings: AppStandardColorings) {
        self.viewModel = ValueObservable(viewModel)
        self.colorings = ValueObservable(colorings)
    }

    var body: some View {
        SearchMessageViewSUI(viewModel: viewModel.value.messageViewModel,
                             colorings: colorings.value)
    }

}

extension SearchNoInternetViewSUI {

    func configure(_ viewModel: SearchNoInternetViewModel,
                   colorings: AppStandardColorings) {
        self.viewModel.value = viewModel
        self.colorings.value = colorings
    }

}
