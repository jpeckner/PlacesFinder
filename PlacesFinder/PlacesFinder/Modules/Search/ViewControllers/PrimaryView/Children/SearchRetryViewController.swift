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

    init(viewModel: SearchRetryViewModel,
         colorings: SearchCTAViewColorings) {
        let contentView = SearchCTAView(viewModel: viewModel.ctaViewModel,
                                        colorings: colorings)

        super.init(contentView: contentView,
                   viewColoring: colorings.viewColoring)
    }

    required init?(coder aDecoder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }

}
