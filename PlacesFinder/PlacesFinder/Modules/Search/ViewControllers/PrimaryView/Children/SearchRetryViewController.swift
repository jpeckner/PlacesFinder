//
//  SearchRetryViewController.swift
//  PlacesFinder
//
//  Created by Justin Peckner.
//  Copyright © 2019 Justin Peckner. All rights reserved.
//

import Shared
import UIKit

extension SearchRetryCopyContent: SearchCTACopyProtocol {}

class SearchRetryViewController: SingleContentViewController {

    init(colorings: SearchCTAViewColorings,
         copyContent: SearchRetryCopyContent,
         retryBlock: @escaping () -> Void) {
        let ctaView = SearchCTAView(viewModel: copyContent.ctaViewModel,
                                    colorings: colorings,
                                    retryBlock: retryBlock)

        super.init(contentView: ctaView,
                   viewColoring: colorings.viewColoring)
    }

    required init?(coder aDecoder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }

}
