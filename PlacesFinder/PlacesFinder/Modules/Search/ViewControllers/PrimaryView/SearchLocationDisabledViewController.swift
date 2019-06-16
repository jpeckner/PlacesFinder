//
//  SearchLocationDisabledViewController.swift
//  PlacesFinder
//
//  Created by Justin Peckner.
//  Copyright © 2019 Justin Peckner. All rights reserved.
//

import Shared
import UIKit

extension SearchLocationDisabledCopyContent: SearchCTACopyProtocol {}

class SearchLocationDisabledViewController: SingleContentViewController, SearchPrimaryViewControllerProtocol {

    enum CTAType {
        case noCTA
        case cta(openSettingsBlock: () -> Void)
    }

    init(appSkin: AppSkin,
         appCopyContent: AppCopyContent,
         ctaType: CTAType) {
        switch ctaType {
        case .noCTA:
            let contentView = SearchMessageView(viewModel: appCopyContent.searchLocationDisabled.messageViewModel,
                                                colorings: appSkin.colorings.standard)

            super.init(contentView: contentView,
                       viewColoring: appSkin.colorings.standard.viewColoring)
        case let .cta(openSettingsBlock):
            let contentView = SearchCTAView(viewModel: appCopyContent.searchLocationDisabled.retryViewModel,
                                            colorings: appSkin.colorings.searchCTA,
                                            retryBlock: openSettingsBlock)

            super.init(contentView: contentView,
                       viewColoring: appSkin.colorings.searchCTA.viewColoring)
        }
    }

    required init?(coder aDecoder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }

}
