//
//  SearchNoInternetViewController.swift
//  PlacesFinder
//
//  Created by Justin Peckner.
//  Copyright © 2019 Justin Peckner. All rights reserved.
//

import Shared
import UIKit

class SearchNoInternetViewController: SingleContentViewController, SearchPrimaryViewControllerProtocol {

    private let messageView: SearchMessageView

    init(viewModel: SearchNoInternetViewModel,
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

extension SearchNoInternetViewController {

    func configure(_ viewModel: SearchNoInternetViewModel,
                   colorings: AppStandardColorings) {
        viewColoring = colorings.viewColoring

        messageView.configure(viewModel.messageViewModel,
                              colorings: colorings)
    }

}
