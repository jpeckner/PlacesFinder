//
//  SearchRetryViewController.swift
//  PlacesFinder
//
//  Created by Justin Peckner.
//  Copyright © 2019 Justin Peckner. All rights reserved.
//

import Shared
import UIKit

class SearchRetryViewController: SingleContentViewController {

    private let ctaView: SearchCTAView

    init(viewModel: SearchRetryViewModel,
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

extension SearchRetryViewController {

    func configure(_ viewModel: SearchRetryViewModel,
                   colorings: SearchCTAViewColorings) {
        ctaView.configure(viewModel.ctaViewModel,
                          colorings: colorings)
    }

}
