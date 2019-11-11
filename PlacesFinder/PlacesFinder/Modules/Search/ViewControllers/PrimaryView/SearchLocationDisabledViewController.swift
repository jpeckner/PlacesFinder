//
//  SearchLocationDisabledViewController.swift
//  PlacesFinder
//
//  Created by Justin Peckner.
//  Copyright © 2019 Justin Peckner. All rights reserved.
//

import Shared
import SwiftUI
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
            let contentView: UIView
            if #available(iOS 13.0, *) {
                let infoViewModel = appCopyContent.searchLocationDisabled.messageViewModel.infoViewModel
                let messageView = SearchMessageViewSUI(viewModel: infoViewModel)
                contentView = UIHostingController(rootView: messageView).view
            } else {
                contentView = SearchMessageView(viewModel: appCopyContent.searchLocationDisabled.messageViewModel,
                                                colorings: appSkin.colorings.standard)
            }

            super.init(contentView: contentView,
                       viewColoring: appSkin.colorings.standard.viewColoring)
        case let .cta(openSettingsBlock):
            let contentView: UIView

            if #available(iOS 13.0, *) {
                let retryModel = appCopyContent.searchLocationDisabled.ctaViewModel
                let viewModel = SearchCTAViewModelSUI(infoViewModel: retryModel.infoViewModel,
                                                      ctaTitle: retryModel.ctaTitle)
                let retryView = SearchCTAViewSUI(viewModel: viewModel,
                                                 colorings: appSkin.colorings.searchCTA,
                                                 retryBlock: openSettingsBlock)
                contentView = UIHostingController(rootView: retryView).view
            } else {
                contentView = SearchCTAView(viewModel: appCopyContent.searchLocationDisabled.ctaViewModel,
                                            colorings: appSkin.colorings.searchCTA,
                                            retryBlock: openSettingsBlock)
            }

            super.init(contentView: contentView,
                       viewColoring: appSkin.colorings.searchCTA.viewColoring)
        }
    }

    required init?(coder aDecoder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }

}
