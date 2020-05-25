//
//  SearchResultsWrapperSUI.swift
//  PlacesFinder
//
//  Created by Justin Peckner on 5/25/20.
//  Copyright © 2020 Justin Peckner. All rights reserved.
//

import Shared
import SwiftUI

struct SearchResultsWrapperSUI: UIViewControllerRepresentable {

    typealias UIViewControllerType = SearchResultsViewController

    @ObservedObject private var viewModel: ValueObservable<SearchResultsViewModel>
    @ObservedObject private var colorings: ValueObservable<SearchResultsViewColorings>

    init(viewModel: SearchResultsViewModel,
         colorings: SearchResultsViewColorings) {
        self.viewModel = ValueObservable(viewModel)
        self.colorings = ValueObservable(colorings)
    }

    func makeUIViewController(context: Context) -> SearchResultsViewController {
        return SearchResultsViewController(viewModel: viewModel.value,
                                           colorings: colorings.value)
    }

    func updateUIViewController(_ controller: SearchResultsViewController, context: Context) {
        controller.configure(viewModel.value,
                             colorings: colorings.value)
    }

}

extension SearchResultsWrapperSUI {

    func configure(_ viewModel: SearchResultsViewModel,
                   colorings: SearchResultsViewColorings) {
        self.viewModel.value = viewModel
        self.colorings.value = colorings
    }

}
