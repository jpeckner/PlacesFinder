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

    private let searchView: SearchLookupView

    init(appSkin: AppSkin,
         appCopyContent: AppCopyContent) {
        self.searchView = SearchLookupView(searchInputViewModel: appCopyContent.searchInput.inputViewModel,
                                           searchInputColorings: appSkin.colorings.searchInput)

        super.init(contentView: searchView,
                   viewColoring: appSkin.colorings.standard.viewColoring)

        let childController = SearchInstructionsViewController(colorings: appSkin.colorings.standard,
                                                               copyContent: appCopyContent.searchInstructions)
        setSingleChildController(childController) {
            searchView.setChildView($0)
        }
    }

    required init?(coder aDecoder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }

}
