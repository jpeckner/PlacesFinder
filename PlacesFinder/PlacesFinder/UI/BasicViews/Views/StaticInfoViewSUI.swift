//
//  StaticInfoViewSUI.swift
//  PlacesFinder
//
//  Created by Justin Peckner.
//  Copyright © 2019 Justin Peckner. All rights reserved.
//

import Shared
import SwiftUI

struct StaticInfoViewSUI: View {

    private let viewModel: StaticInfoViewModel
    private let colorings: AppStandardColorings

    init(viewModel: StaticInfoViewModel,
         colorings: AppStandardColorings) {
        self.viewModel = viewModel
        self.colorings = colorings
    }

    var body: some View {
        VStack {
            Image(viewModel.imageName)
                .resizable()
                .aspectRatio(contentMode: .fit)
                .frame(idealHeight: 240.0,
                       alignment: .center)

            StyledText(text: viewModel.title,
                       styleClass: .title,
                       textColoring: colorings.titleTextColoring)
                .lineLimit(1)
                .allowsTightening(true)
                .minimumScaleFactor(0.5)

            StyledText(text: viewModel.description,
                       styleClass: .body,
                       textColoring: colorings.bodyTextColoring)
                .fixedSize(horizontal: false, vertical: true)
        }
    }

}
