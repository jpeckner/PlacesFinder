//
//  SearchBackgroundViewController.swift
//  PlacesFinder
//
//  Created by Justin Peckner.
//  Copyright © 2019 Justin Peckner. All rights reserved.
//

import Shared
import UIKit

class SearchBackgroundViewController: SingleContentViewController, SearchPrimaryViewControllerProtocol {

    private let lookupView: SearchLookupView
    private let childController: SearchInstructionsViewController

    init(viewModel: SearchBackgroundViewModel,
         appSkin: AppSkin) {
        self.lookupView = SearchLookupView(searchInputViewModel: viewModel.inputViewModel,
                                           searchInputColorings: appSkin.colorings.searchInput)
        self.childController = SearchInstructionsViewController(viewModel: viewModel.instructionsViewModel,
                                                                colorings: appSkin.colorings.standard)

        super.init(contentView: lookupView,
                   viewColoring: appSkin.colorings.standard.viewColoring)

        setSingleChildController(childController) {
            lookupView.setChildView($0)
        }
    }

    required init?(coder aDecoder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }

}

extension SearchBackgroundViewController {

    func configure(_ viewModel: SearchBackgroundViewModel,
                   appSkin: AppSkin) {
        viewColoring = appSkin.colorings.standard.viewColoring

        lookupView.configure(viewModel.inputViewModel,
                             colorings: appSkin.colorings.searchInput)

        childController.configure(viewModel.instructionsViewModel,
                                  colorings: appSkin.colorings.standard)
    }

}
