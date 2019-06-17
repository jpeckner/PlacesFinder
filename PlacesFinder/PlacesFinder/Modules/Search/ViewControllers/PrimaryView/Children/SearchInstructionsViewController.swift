//
//  SearchInstructionsViewController.swift
//  PlacesFinder
//
//  Created by Justin Peckner.
//  Copyright © 2019 Justin Peckner. All rights reserved.
//

import Shared
import UIKit

extension SearchInstructionsCopyContent: StaticInfoCopyProtocol {}

class SearchInstructionsViewController: SingleContentViewController {

    init(colorings: AppStandardColorings,
         copyContent: SearchInstructionsCopyContent) {
        let viewModel = SearchInstructionsViewModel(infoViewModel: copyContent.staticInfoViewModel,
                                                    resultsSourceCopy: copyContent.resultsSource)
        let messageView = SearchInstructionsView(viewModel: viewModel,
                                                 colorings: colorings)

        super.init(contentView: messageView,
                   viewColoring: colorings.viewColoring)
    }

    required init?(coder aDecoder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }

}
