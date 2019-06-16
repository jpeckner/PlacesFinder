//
//  SearchNoResultsFoundViewController.swift
//  PlacesFinder
//
//  Created by Justin Peckner.
//  Copyright © 2019 Justin Peckner. All rights reserved.
//

import Shared
import UIKit

extension SearchNoResultsCopyContent: StaticInfoCopyProtocol {}

class SearchNoResultsFoundViewController: SingleContentViewController {

    init(colorings: AppStandardColorings,
         copyContent: SearchNoResultsCopyContent) {
        let messageView = SearchMessageView(viewModel: copyContent.messageViewModel,
                                            colorings: colorings)

        super.init(contentView: messageView,
                   viewColoring: colorings.viewColoring)
    }

    required init?(coder aDecoder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }

}
