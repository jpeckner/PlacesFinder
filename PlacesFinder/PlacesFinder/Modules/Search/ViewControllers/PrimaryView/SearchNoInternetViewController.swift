//
//  SearchNoInternetViewController.swift
//  PlacesFinder
//
//  Created by Justin Peckner.
//  Copyright © 2019 Justin Peckner. All rights reserved.
//

import Shared
import UIKit

extension SearchNoInternetCopyContent: StaticInfoCopyProtocol {}

class SearchNoInternetViewController: SingleContentViewController, SearchPrimaryViewControllerProtocol {

    init(appSkin: AppSkin,
         appCopyContent: AppCopyContent) {
        let messageView = SearchMessageView(viewModel: appCopyContent.searchNoInternet.messageViewModel,
                                            colorings: appSkin.colorings.standard)

        super.init(contentView: messageView,
                   viewColoring: appSkin.colorings.standard.viewColoring)
    }

    required init?(coder aDecoder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }

}
