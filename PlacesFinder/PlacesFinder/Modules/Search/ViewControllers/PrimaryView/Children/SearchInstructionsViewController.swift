//
//  SearchInstructionsViewController.swift
//  PlacesFinder
//
//  Created by Justin Peckner.
//  Copyright © 2019 Justin Peckner. All rights reserved.
//

import Shared
import UIKit

class SearchInstructionsViewController: SingleContentViewController {

    private let instructionsView: SearchInstructionsView

    init(viewModel: SearchInstructionsViewModel,
         colorings: AppStandardColorings) {
        self.instructionsView = SearchInstructionsView(viewModel: viewModel,
                                                       colorings: colorings)

        super.init(contentView: instructionsView,
                   viewColoring: colorings.viewColoring)
    }

    required init?(coder aDecoder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }

}

extension SearchInstructionsViewController {

    func configure(_ viewModel: SearchInstructionsViewModel,
                   colorings: AppStandardColorings) {
        viewColoring = colorings.viewColoring

        instructionsView.configure(viewModel,
                                   colorings: colorings)
    }

}
