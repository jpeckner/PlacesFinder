//
//  SearchNoResultsFoundViewController.swift
//  PlacesFinder
//
//  Created by Justin Peckner.
//  Copyright © 2019 Justin Peckner. All rights reserved.
//

import Shared
import UIKit

class SearchNoResultsFoundViewController: SingleContentViewController {

    private let messageView: SearchMessageView

    init(viewModel: SearchNoResultsFoundViewModel,
         colorings: AppStandardColorings) {
        self.messageView = SearchMessageView(viewModel: viewModel.messageViewModel,
                                             colorings: colorings)

        super.init(contentView: messageView,
                   viewColoring: colorings.viewColoring)
    }

    required init?(coder aDecoder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }

}

extension SearchNoResultsFoundViewController {

    func configure(_ viewModel: SearchNoResultsFoundViewModel,
                   colorings: AppStandardColorings) {
        messageView.configure(viewModel.messageViewModel,
                              colorings: colorings)
    }

}
