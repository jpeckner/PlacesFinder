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

    init(viewModel: SearchNoResultsFoundViewModel,
         colorings: AppStandardColorings) {
        let messageView = SearchMessageView(viewModel: viewModel.messageViewModel,
                                            colorings: colorings)

        super.init(contentView: messageView,
                   viewColoring: colorings.viewColoring)
    }

    required init?(coder aDecoder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }

}
