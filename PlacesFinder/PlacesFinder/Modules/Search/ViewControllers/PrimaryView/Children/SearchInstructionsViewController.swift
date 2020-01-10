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

    private let contentView: SearchInstructionsView

    init(viewModel: SearchInstructionsViewModel,
         colorings: AppStandardColorings) {
        self.contentView = SearchInstructionsView(viewModel: viewModel,
                                                  colorings: colorings)

        super.init(contentView: contentView,
                   viewColoring: colorings.viewColoring)
    }

    required init?(coder aDecoder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }

}

extension SearchInstructionsViewController {

    func configure(_ viewModel: SearchInstructionsViewModel) {
        contentView.configure(viewModel)
    }

}
