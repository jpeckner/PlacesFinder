//
//  SearchLocationDisabledViewController.swift
//  PlacesFinder
//
//  Created by Justin Peckner.
//  Copyright © 2019 Justin Peckner. All rights reserved.
//

import Shared

class SearchLocationDisabledViewController: SingleContentViewController, SearchPrimaryViewControllerProtocol {

    private let ctaView: SearchCTAView

    init(viewModel: SearchLocationDisabledViewModel,
         colorings: SearchCTAViewColorings) {
        self.ctaView = SearchCTAView(viewModel: viewModel.ctaViewModel,
                                     colorings: colorings)

        super.init(contentView: ctaView,
                   viewColoring: colorings.viewColoring)
    }

    required init?(coder aDecoder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }

}

extension SearchLocationDisabledViewController {

    func configure(_ viewModel: SearchLocationDisabledViewModel) {
        ctaView.configure(viewModel.ctaViewModel)
    }

}
