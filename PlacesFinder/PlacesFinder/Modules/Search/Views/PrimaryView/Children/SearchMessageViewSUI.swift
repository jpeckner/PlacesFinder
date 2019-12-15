//
//  SearchMessageViewSUI.swift
//  PlacesFinder
//
//  Created by Justin Peckner.
//  Copyright © 2019 Justin Peckner. All rights reserved.
//

import SwiftUI

@available(iOS 13.0, *)
struct SearchMessageViewSUI: View {

    private let viewModel: StaticInfoViewModel

    init(viewModel: StaticInfoViewModel) {
        self.viewModel = viewModel
    }

    var body: some View {
        StaticInfoViewSUI(viewModel: viewModel).padding()
    }

}
