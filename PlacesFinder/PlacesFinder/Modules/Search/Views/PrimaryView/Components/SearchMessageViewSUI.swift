//
//  SearchMessageViewSUI.swift
//  PlacesFinder
//
//  Created by Justin Peckner.
//  Copyright © 2019 Justin Peckner. All rights reserved.
//

import SwiftUI

struct SearchMessageViewSUI: View {

    private let viewModel: SearchMessageViewModel
    private let colorings: AppStandardColorings

    init(viewModel: SearchMessageViewModel,
         colorings: AppStandardColorings) {
        self.viewModel = viewModel
        self.colorings = colorings
    }

    var body: some View {
        StaticInfoViewSUI(viewModel: viewModel.infoViewModel, colorings: colorings)
            .padding()
    }

}
