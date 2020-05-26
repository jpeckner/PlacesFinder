//
//  NavigationBarTitleViewSUI.swift
//  PlacesFinder
//
//  Created by Justin Peckner.
//  Copyright © 2019 Justin Peckner. All rights reserved.
//

import Shared
import SwiftUI

struct NavigationBarTitleViewSUI: View {

    private let viewModel: NavigationBarTitleViewModel
    private let colorings: NavBarColorings

    init(viewModel: NavigationBarTitleViewModel,
         colorings: NavBarColorings) {
        self.viewModel = viewModel
        self.colorings = colorings
    }

    var body: some View {
        HStack {
            Image(uiImage: #imageLiteral(resourceName: "magnifying_glass"))

            StyledText(text: viewModel.displayName,
                       styleClass: .navBarTitle,
                       textColoring: colorings.titleTextColoring)
        }
    }

}
