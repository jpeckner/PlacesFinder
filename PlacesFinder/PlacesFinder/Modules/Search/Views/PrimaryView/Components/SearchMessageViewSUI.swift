//
//  SearchMessageViewSUI.swift
//  PlacesFinder
//
//  Created by Justin Peckner.
//  Copyright © 2019 Justin Peckner. All rights reserved.
//

import Shared
import SwiftUI

struct SearchMessageViewSUI: View {

    @ObservedObject private var viewModel: ValueObservable<SearchMessageViewModel>
    @ObservedObject private var colorings: ValueObservable<AppStandardColorings>

    init(viewModel: SearchMessageViewModel,
         colorings: AppStandardColorings) {
        self.viewModel = ValueObservable(viewModel)
        self.colorings = ValueObservable(colorings)
    }

    var body: some View {
        StaticInfoViewSUI(viewModel: viewModel.value.infoViewModel,
                          colorings: colorings.value)
            .padding()
    }

}

extension SearchMessageViewSUI {

    func configure(_ viewModel: SearchMessageViewModel,
                   colorings: AppStandardColorings) {
        self.viewModel.value = viewModel
        self.colorings.value = colorings
    }

}
