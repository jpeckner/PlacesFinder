//
//  StaticInfoViewSUI.swift
//  PlacesFinder
//
//  Created by Justin Peckner.
//  Copyright © 2019 Justin Peckner. All rights reserved.
//

import Shared
import SwiftUI

@available(iOS 13.0, *)
struct StaticInfoViewSUI: View {

    private enum Constants {
        static let imageHeight: CGFloat = 240.0
    }

    @Binding var viewModel: StaticInfoViewModel

    var body: some View {
        VStack {
            Image(uiImage: viewModel.image)
                .resizable()
                .frame(width: viewModel.image.widthToHeightRatio * Constants.imageHeight,
                       height: Constants.imageHeight,
                       alignment: .center)
                .aspectRatio(contentMode: .fit)

            StyledLabelSUI(text: viewModel.title, styleClass: .title)

            StyledLabelSUI(text: viewModel.description, styleClass: .body)
        }
    }

}
