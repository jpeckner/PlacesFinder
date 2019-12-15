//
//  SearchInstructionsViewController.swift
//  PlacesFinder
//
//  Created by Justin Peckner.
//  Copyright © 2019 Justin Peckner. All rights reserved.
//

import Shared
import SwiftUI
import UIKit

extension SearchInstructionsCopyContent: StaticInfoCopyProtocol {}

class SearchInstructionsViewController: SingleContentViewController {

    init(colorings: AppStandardColorings,
         copyContent: SearchInstructionsCopyContent) {
        let contentView: UIView

        if #available(iOS 13.0, *) {
            let viewModel = SearchInstructionsViewModel(infoViewModel: copyContent.staticInfoViewModel,
                                                        resultsSourceCopy: copyContent.resultsSource)
            let messageView = SearchInstructionsViewSUI(viewModel: viewModel,
                                                        colorings: colorings)
            contentView = UIHostingController(rootView: messageView).view
        } else {
            let viewModel = SearchInstructionsViewModel(infoViewModel: copyContent.staticInfoViewModel,
                                                        resultsSourceCopy: copyContent.resultsSource)
            contentView = SearchInstructionsView(viewModel: viewModel,
                                                 colorings: colorings)
        }

        super.init(contentView: contentView,
                   viewColoring: colorings.viewColoring)
    }

    required init?(coder aDecoder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }

}
