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

    private let contentView: SearchMessageView

    init(viewModel: SearchNoInternetViewModel,
         colorings: AppStandardColorings) {
        self.contentView = SearchMessageView(viewModel: viewModel.messageViewModel,
                                             colorings: colorings)

        super.init(contentView: contentView,
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

        contentView.configure(viewModel.messageViewModel,
                              colorings: colorings)
    }

}
