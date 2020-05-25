//
//  DownloadedImageViewSUI.swift
//  PlacesFinder
//
//  Created by Justin Peckner.
//  Copyright © 2020 Justin Peckner. All rights reserved.
//

import KingfisherSwiftUI
import SwiftUI

struct DownloadedImageViewSUI: View {

    private let viewModel: DownloadedImageViewModel

    init(viewModel: DownloadedImageViewModel) {
        self.viewModel = viewModel
    }

    var body: some View {
        KFImage(viewModel.url)
            .cancelOnDisappear(true)
            .resizable()
            .placeholder {
                Image(uiImage: UIImage(named: viewModel.placeholderName) ?? #imageLiteral(resourceName: "magnifying_glass"))
            }
    }

}
