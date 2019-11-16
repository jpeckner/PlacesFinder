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

    @State var viewModel: StaticInfoViewModel

    var body: some View {
        StaticInfoViewSUI(viewModel: $viewModel).padding()
    }

}
