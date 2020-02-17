//
//  SearchNoInternetViewSUI.swift
//  PlacesFinder
//
//  Created by Justin Peckner.
//  Copyright © 2020 Justin Peckner. All rights reserved.
//

import Shared
import SwiftUI

@available(iOS 13.0, *)
struct SearchNoInternetViewSUI: View {

    @ObservedObject var viewModel: ValueObservable<SearchNoInternetViewModel>
    @ObservedObject var colorings: ValueObservable<AppStandardColorings>

    init(viewModel: SearchNoInternetViewModel,
         colorings: AppStandardColorings) {
        self.viewModel = ValueObservable(value: viewModel)
        self.colorings = ValueObservable(value: colorings)
    }

    var body: some View {
        SearchMessageViewSUI(viewModel: viewModel.value.messageViewModel,
                             colorings: colorings.value)
    }

}
