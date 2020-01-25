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
         appSkin: AppSkin) {
        self.contentView = SearchMessageView(viewModel: viewModel.messageViewModel,
                                             colorings: appSkin.colorings.standard)

        super.init(contentView: contentView,
                   viewColoring: appSkin.colorings.standard.viewColoring)
    }

    required init?(coder aDecoder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }

}

extension SearchNoInternetViewController {

    func configure(_ viewModel: SearchNoInternetViewModel) {
        contentView.configure(viewModel.messageViewModel)
    }

}
